// api/genereer-concept.js
// POST — Verwerkt aangevinkte analysepunten in een verbeterde versie van het document.
// Retourneert JSON: { documentTekst, wijzigingen }
// wijzigingen bevat originele_tekst + aangepaste_tekst voor track-changes weergave.

import https from 'https';

export const config = {
  api: { bodyParser: { sizeLimit: '12mb' } },
};

// Omzeilt Vercel/undici headersTimeout door Node's https.request() te gebruiken,
// dat geen headers-timeout kent (alleen een inactiviteits-timeout op de socket).
function anthropicPost(apiKey, body) {
  return new Promise((resolve, reject) => {
    const payload = JSON.stringify(body);
    const req = https.request({
      hostname: 'api.anthropic.com',
      path:     '/v1/messages',
      method:   'POST',
      headers: {
        'Content-Type':      'application/json',
        'Content-Length':    Buffer.byteLength(payload),
        'x-api-key':         apiKey,
        'anthropic-version': '2023-06-01',
      },
      timeout: 115_000, // 115 s socket-inactiviteits-timeout (< Vercel maxDuration 120s)
    }, (res) => {
      let data = '';
      res.on('data', chunk => (data += chunk));
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch (e) {
          reject(new Error(`JSON-parse mislukt: ${data.slice(0, 200)}`));
        }
      });
    });
    req.on('error',   reject);
    req.on('timeout', () => { req.destroy(); reject(new Error('Anthropic API timeout (115 s)')); });
    req.write(payload);
    req.end();
  });
}

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Alleen POST toegestaan' });

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return res.status(500).json({ error: 'ANTHROPIC_API_KEY niet geconfigureerd' });

  const { documentTekst, aangevinkt, documentType, bestandsnaam } = req.body;
  if (!documentTekst?.trim()) return res.status(400).json({ error: 'documentTekst ontbreekt' });
  if (!aangevinkt?.length)    return res.status(400).json({ error: 'Geen aangevinkte punten' });

  // ── Formatteer verbeterpunten voor de prompt ──────────
  const itemsTekst = aangevinkt.map((item, i) => {
    const nr  = i + 1;
    const cat = item.categorie || '?';
    const loc = item.locatie || item.sectie || item.onderwerp || item.signalering || '';
    const bev = item.bevinding || item.toelichting || item.probleem || item.signalering || '';
    const sug = item.suggestie || '';
    const opm = item.opmerking || '';
    const pas = item.passage   || item.citaat || '';
    let tekst = `[${nr}] (${cat})`;
    if (loc) tekst += `\n   Locatie: ${loc}`;
    if (bev) tekst += `\n   Bevinding: ${bev}`;
    if (sug) tekst += `\n   Suggestie: ${sug}`;
    if (opm) tekst += `\n   Opmerking mediator: ${opm}`;
    if (pas) tekst += `\n   Passage in document: "${pas}"`;
    return tekst;
  }).join('\n\n');

  const systemPrompt =
`Je bent een ervaren Nederlandse juridische documentschrijver gespecialiseerd in echtscheidingsdocumenten. Je taak is het aanpassen van specifieke passages op basis van de gegeven verbeterpunten.

KERNREGELS:
1. Geef ALLEEN de gewijzigde passages terug — herschrijf NOOIT het volledige document.
2. Behoud de formele toon, nummering en stijl van het origineel in de aangepaste tekst.
3. Verwijder NOOIT volledige artikelen of secties tenzij een verbeterpunt dit expliciet vereist.
4. Als een aanpassing logische gevolgen heeft voor een ander artikel, vermeld dat dan in ook_aangepast.
5. Als een verbeterpunt een concrete "Suggestie" bevat, gebruik die formulering letterlijk tenzij het de samenhang schaadt.
6. Gebruik NIET de termen "Partij A" of "Partij B" als het origineel concrete namen gebruikt — behoud die namen.

VERVANGING VAN BESTAANDE TEKST (meest gebruikelijk):
7. Vul originele_tekst met de EXACTE woordelijke tekst uit het document (inclusief nummering, spaties en leestekens).
   De tekst wordt letterlijk gezocht — elke afwijking betekent dat de wijziging niet toegepast kan worden.
   Neem minimaal één volledige zin op. Laat invoeg_na leeg ("").

INVOEGEN VAN NIEUWE SECTIES (alleen als het verbeterpunt een nieuw artikel/sectie vereist):
8. Laat originele_tekst leeg ("").
   Vul invoeg_na met de EXACTE tekst van het laatste woord/zin van het artikel NA welke ingevoegd wordt.
   Vul aangepaste_tekst met de volledige nieuwe sectietekst (inclusief nummering).
   Dit is alleen voor inhoud die volledig NIEUW is en niet al ergens in het document staat.`;

  const userPrompt =
`DOCUMENTTYPE: ${documentType || 'echtscheidingsdocument'}

TE VERWERKEN VERBETERPUNTEN (${aangevinkt.length} stuks):
${itemsTekst}

Geef per verbeterpunt ALLEEN de gewijzigde passage terug.
- Bestaande tekst aanpassen → originele_tekst invullen, invoeg_na leeg laten.
- Nieuw artikel toevoegen → invoeg_na invullen (tekst NA welke ingevoegd wordt), originele_tekst leeg laten.
Herschrijf het volledige document NIET.

ORIGINEEL DOCUMENT:
${documentTekst}`;

  // Alleen wijzigingen ophalen — NIET het volledige document herschrijven.
  // Het document wordt serverside gereconstrueerd door de wijzigingen toe te passen.
  // Dit bespaart ~80–90% van de output-tokens en verlaagt de wachttijd van ~2 min naar ~15 sec.
  const tool = {
    name: 'document_wijzigingen',
    description: 'Levert uitsluitend de gewijzigde passages (origineel → aangepast). Het volledige document hoeft NIET te worden herhaald.',
    input_schema: {
      type: 'object',
      properties: {
        wijzigingen: {
          type: 'array',
          description: 'Één item per verbeterpunt — alleen de gewijzigde passages, niet het hele document',
          items: {
            type: 'object',
            properties: {
              item_nr:         { type: 'integer', description: 'Nummer van het verbeterpunt (1-based)' },
              artikel:         { type: 'string',  description: 'Welk artikel of welke sectie is gewijzigd of toegevoegd' },
              wat_gewijzigd:   { type: 'string',  description: 'Beknopte omschrijving van de aanpassing (max 2 zinnen)' },
              originele_tekst: { type: 'string',  description: 'VERVANGING: de EXACTE woordelijke tekst uit het document die vervangen wordt. Leeg laten bij nieuwe secties.' },
              invoeg_na:       { type: 'string',  description: 'INVOEGING: de EXACTE tekst van de zin/het artikel NA welke de nieuwe sectie ingevoegd wordt. Leeg laten bij vervangingen.' },
              aangepaste_tekst:{ type: 'string',  description: 'De nieuwe/vervangende tekst zoals die in het document moet staan' },
              ook_aangepast:   {
                type: 'array',
                items: { type: 'string' },
                description: 'Andere artikelen/secties die vanwege samenhang óók zijn aangepast (leeg als geen)',
              },
            },
            required: ['item_nr', 'artikel', 'wat_gewijzigd', 'originele_tekst', 'invoeg_na', 'aangepaste_tekst', 'ook_aangepast'],
          },
        },
      },
      required: ['wijzigingen'],
    },
  };

  try {
    const { status, body: json } = await anthropicPost(apiKey, {
      model:       'claude-sonnet-4-6',
      max_tokens:  4096,   // alleen wijzigingen → veel minder tokens nodig
      temperature: 0,
      system:      systemPrompt,
      messages: [{ role: 'user', content: userPrompt }],
      tools: [tool],
      tool_choice: { type: 'tool', name: tool.name },
    });

    if (status >= 400) {
      throw new Error(`Anthropic API fout (${status}): ${JSON.stringify(json)}`);
    }

    if (json.stop_reason === 'max_tokens') {
      console.warn('[genereer-concept] max_tokens bereikt — sommige wijzigingen mogelijk afgekapt');
    }

    const toolUse = json.content?.find(b => b.type === 'tool_use');
    if (!toolUse?.input) {
      throw new Error('Claude gaf geen gestructureerde output terug');
    }

    const wijzigingen = toolUse.input.wijzigingen || [];

    // ── Hulpfuncties voor tekst-matching ─────────────────────────────────
    // Normaliseert tekst: zachte koppeltekens, non-breaking spaties,
    // typografische aanhalingstekens, em/en-dash en overbodige witruimte.
    const normaliseer = (s) => (s || '')
      .replace(/­/g, '')                          // zachte koppeltekens
      .replace(/[   ]/g, ' ')           // non-breaking/dunne spaties
      .replace(/[‘’`´]/g, "'")     // curly/backtick single quotes
      .replace(/[“”«»„]/g, '"') // curly double quotes
      .replace(/…/g, '...')                       // ellipsis
      .replace(/[–—―]/g, '-')           // en/em/horizontale streep
      .replace(/\s+/g, ' ')                            // meerdere spaties
      .trim();

    // Bouwt een regex die tolerant is voor whitespace-variaties in rawText.
    // Elk spatie-karakter in de zoekterm matcht één of meer whitespace-tekens.
    const maakRegex = (zoekTekst) => {
      const norm = normaliseer(zoekTekst);
      const escaped = norm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
      const patroon = escaped.replace(/ /g, '[\\s\\u00A0\\u00AD]+');
      return new RegExp(patroon, 's'); // dotAll: . matcht ook newlines
    };

    // Vindt zoekTekst in docTekst (exact, dan flex) en retourneert {start, end} of null.
    const vindPositie = (docTekst, zoekTekst) => {
      if (!zoekTekst?.trim()) return null;
      // 1. Exacte match
      const exactIdx = docTekst.indexOf(zoekTekst);
      if (exactIdx >= 0) return { start: exactIdx, end: exactIdx + zoekTekst.length };
      // 2. Flexibele regex-match (whitespace + speciale tekens)
      const match = maakRegex(zoekTekst).exec(docTekst);
      if (match) return { start: match.index, end: match.index + match[0].length };
      return null;
    };

    // ── Reconstructie ────────────────────────────────────────────────────
    let docTekst = documentTekst;
    let toegepast = 0;

    for (const w of wijzigingen) {
      if (w.aangepaste_tekst == null) continue;

      const heeftInvoegNa   = w.invoeg_na?.trim();
      const heeftOrigineel  = w.originele_tekst?.trim();

      if (heeftInvoegNa) {
        // ── INVOEGING: nieuwe sectie toevoegen na ankertekst ──────────
        const pos = vindPositie(docTekst, w.invoeg_na);
        if (pos) {
          docTekst = docTekst.slice(0, pos.end) + '\n\n' + w.aangepaste_tekst + docTekst.slice(pos.end);
          toegepast++;
        } else {
          console.warn(`[genereer-concept] invoeg_na niet gevonden voor item ${w.item_nr}: "${w.invoeg_na?.slice(0, 60)}…"`);
        }
      } else if (heeftOrigineel) {
        // ── VERVANGING: bestaande tekst vervangen ────────────────────
        const pos = vindPositie(docTekst, w.originele_tekst);
        if (pos) {
          docTekst = docTekst.slice(0, pos.start) + w.aangepaste_tekst + docTekst.slice(pos.end);
          toegepast++;
        } else {
          console.warn(`[genereer-concept] originele_tekst niet gevonden voor item ${w.item_nr}: "${w.originele_tekst?.slice(0, 60)}…"`);
        }
      }
    }
    console.log(`[genereer-concept] ${toegepast}/${wijzigingen.length} wijzigingen toegepast in reconstructie`);

    return res.status(200).json({
      documentTekst: docTekst,
      wijzigingen,
    });
  } catch (err) {
    console.error('[genereer-concept]', err);
    return res.status(500).json({ error: err.message });
  }
}
