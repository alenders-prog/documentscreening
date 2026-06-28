// api/genereer-concept.js
// POST — Verwerkt aangevinkte analysepunten in een verbeterde versie van het document.
// Retourneert JSON: { documentTekst, wijzigingen }
// wijzigingen bevat originele_tekst + aangepaste_tekst voor track-changes weergave.

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
`Je bent een ervaren Nederlandse juridische documentschrijver gespecialiseerd in echtscheidingsdocumenten. Je taak is het aanpassen van een bestaand document op basis van geselecteerde verbeterpunten.

KERNREGELS:
1. Behoud EXACT de structuur, nummering, koppen, volgorde van artikelen en de formele toon van het origineel.
2. Pas ALLEEN aan wat nodig is voor de opgegeven verbeterpunten. Herschrijf nooit het gehele document.
3. Verwijder NOOIT volledige artikelen of secties tenzij een verbeterpunt dit expliciet vereist.
4. Als een aanpassing logische gevolgen heeft voor een ander artikel (bijv. pensioen in art. 5 hangt samen met een verwijzing in art. 2), pas dat artikel óók aan.
5. Als een verbeterpunt een concrete "Suggestie" bevat, gebruik die formulering letterlijk tenzij het de samenhang schaadt.
6. Gebruik de formele Nederlandse juridische schrijfstijl die in het origineel wordt gehanteerd.
7. Gebruik NIET de termen "Partij A" of "Partij B" als het origineel concrete namen gebruikt — behoud die namen.
8. Elk verbeterpunt krijgt precies één item in wijzigingen, met:
   - originele_tekst: de WOORDELIJKE tekst uit het origineel die is aangepast (minstens één volledige zin)
   - aangepaste_tekst: de vervangende tekst zoals die in het definitieve document staat`;

  const userPrompt =
`DOCUMENTTYPE: ${documentType || 'echtscheidingsdocument'}

TE VERWERKEN VERBETERPUNTEN (${aangevinkt.length} stuks):
${itemsTekst}

ORIGINEEL DOCUMENT:
${documentTekst}`;

  const tool = {
    name: 'verbeterd_document',
    description: 'Levert het volledig aangepaste document en een wijzigingslog met originele en nieuwe tekstparen',
    input_schema: {
      type: 'object',
      properties: {
        document_tekst: {
          type: 'string',
          description:
            'Het VOLLEDIGE aangepaste document. Neem ook alle ongewijzigde artikelen op — het resultaat moet een compleet en direct te gebruiken document zijn.',
        },
        wijzigingen: {
          type: 'array',
          description: 'Log van elke aangebrachte wijziging (één item per verbeterpunt)',
          items: {
            type: 'object',
            properties: {
              item_nr:         { type: 'integer', description: 'Nummer van het verbeterpunt (1-based)' },
              artikel:         { type: 'string',  description: 'Welk artikel of welke sectie is gewijzigd' },
              wat_gewijzigd:   { type: 'string',  description: 'Beknopte omschrijving van de aanpassing (max 2 zinnen)' },
              originele_tekst: { type: 'string',  description: 'De EXACTE originele tekst uit het document die is vervangen (woordelijk, minstens één volledige zin)' },
              aangepaste_tekst:{ type: 'string',  description: 'De vervangende tekst zoals die nu in het definitieve document staat' },
              ook_aangepast:   {
                type: 'array',
                items: { type: 'string' },
                description: 'Andere artikelen/secties die ook zijn aangepast vanwege samenhang (leeg als geen)',
              },
            },
            required: ['item_nr', 'artikel', 'wat_gewijzigd', 'originele_tekst', 'aangepaste_tekst', 'ook_aangepast'],
          },
        },
      },
      required: ['document_tekst', 'wijzigingen'],
    },
  };

  try {
    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type':      'application/json',
        'x-api-key':         apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model:       'claude-sonnet-4-6',
        max_tokens:  16000,
        temperature: 0,
        system:      systemPrompt,
        messages: [{ role: 'user', content: userPrompt }],
        tools: [tool],
        tool_choice: { type: 'tool', name: tool.name },
      }),
    });

    if (!response.ok) {
      const errText = await response.text();
      throw new Error(`Anthropic API fout (${response.status}): ${errText}`);
    }

    const json = await response.json();

    if (json.stop_reason === 'max_tokens') {
      console.warn('[genereer-concept] max_tokens bereikt — document mogelijk afgekapt');
    }

    const toolUse = json.content?.find(b => b.type === 'tool_use');
    if (!toolUse?.input?.document_tekst) {
      throw new Error('Claude gaf geen gestructureerde output terug');
    }

    return res.status(200).json({
      documentTekst: toolUse.input.document_tekst,
      wijzigingen:   toolUse.input.wijzigingen || [],
    });
  } catch (err) {
    console.error('[genereer-concept]', err);
    return res.status(500).json({ error: err.message });
  }
}
