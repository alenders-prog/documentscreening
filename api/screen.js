/**
 * api/screen.js
 *
 * Eén endpoint: POST { filename, content_base64 } -> screeningsrapport.
 *
 * Hergebruikt de bestaande kennisbank (document_templates, legal_chunks,
 * situatie_kenmerken) — geen embeddings nodig voor dit endpoint: de
 * koppeling gaat via de topic_tags/situatie_kenmerken die al overlappen,
 * dus gewone Supabase-filters zijn hier voldoende en sneller dan retrieval.
 */

import { createClient } from '@supabase/supabase-js';
import mammoth from 'mammoth';
import pdf from 'pdf-parse';

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

async function askClaude(systemPrompt, userPrompt, maxTokens = 2048) {
  const res = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': process.env.ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: 'claude-sonnet-4-6',
      max_tokens: maxTokens,
      system: systemPrompt,
      messages: [{ role: 'user', content: userPrompt }],
    }),
  });
  if (!res.ok) throw new Error(`Claude API fout (${res.status}): ${await res.text()}`);
  const json = await res.json();
  return json.content.map((b) => (b.type === 'text' ? b.text : '')).join('\n').trim();
}

function parseJsonLoosely(text) {
  // Claude antwoordt soms met ```json ... ``` erom heen, ondanks instructie.
  const schoon = text.replace(/^```json\s*|```$/g, '').trim();
  return JSON.parse(schoon);
}

async function extractText(filename, buffer) {
  if (filename.toLowerCase().endsWith('.docx')) {
    const { value } = await mammoth.extractRawText({ buffer });
    return value;
  }
  if (filename.toLowerCase().endsWith('.pdf')) {
    const data = await pdf(buffer);
    return data.text;
  }
  throw new Error('Alleen .docx en .pdf worden ondersteund.');
}

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Alleen POST' });

  try {
    const { filename, content_base64 } = req.body;
    if (!filename || !content_base64) {
      return res.status(400).json({ error: 'filename en content_base64 zijn verplicht' });
    }

    const buffer = Buffer.from(content_base64, 'base64');
    const documentTekst = await extractText(filename, buffer);

    if (documentTekst.trim().length < 200) {
      return res.status(400).json({ error: 'Kon weinig tot geen tekst uit het bestand halen. Is het leesbaar?' });
    }

    // 1. Situatie classificeren, op basis van de bestaande taxonomie.
    const { data: kenmerken } = await supabase.from('situatie_kenmerken').select('key, label, categorie');
    const kenmerkenLijst = kenmerken.map((k) => `${k.key} (${k.label})`).join(', ');

    const classificatieRuw = await askClaude(
      `Je classificeert een Nederlands echtscheidingsdocument. Antwoord UITSLUITEND met JSON, geen omloop-tekst, in dit formaat:
{"doc_type": "convenant" | "ouderschapsplan" | "onbekend", "situatie_kenmerken": ["key1","key2"], "samenvatting": "1-2 zinnen"}
Gebruik voor situatie_kenmerken UITSLUITEND keys uit deze lijst: ${kenmerkenLijst}`,
      documentTekst.slice(0, 6000),
      512
    );
    const classificatie = parseJsonLoosely(classificatieRuw);

    // 2. Checklist ophalen: welke secties horen er volgens het sjabloon te zijn?
    const { data: templates } = await supabase
      .from('document_templates')
      .select('section_name, required, applies_when, instructions')
      .eq('doc_type', classificatie.doc_type === 'onbekend' ? 'convenant' : classificatie.doc_type)
      .order('section_order');

    const checklist = (templates ?? []).filter(
      (t) => !t.applies_when || t.applies_when.every((tag) => classificatie.situatie_kenmerken.includes(tag))
    );

    // 3. Relevante wetsartikelen: via topic_tags-overlap, geen embeddings nodig.
    const { data: wetteksten } = await supabase
      .from('legal_chunks')
      .select('citation, content, topic_tags')
      .overlaps('topic_tags', classificatie.situatie_kenmerken)
      .limit(20);

    // 4. Het hoofdrapport.
    const checklistTekst = checklist.map((c) => `- ${c.section_name}: ${c.instructions ?? '(vaste tekst, geen specifieke inhoud)'}`).join('\n');
    const wetTekst = (wetteksten ?? []).map((w) => `[${w.citation}] ${w.content}`).join('\n\n');

    const rapportRuw = await askClaude(
      `Je bent een ervaren familiemediator die een al opgesteld echtscheidingsdocument controleert.
Antwoord UITSLUITEND met JSON in dit formaat, geen omloop-tekst:
{
  "grammatica": [{"locatie": "korte aanduiding", "probleem": "...", "suggestie": "..."}],
  "juridisch": [{"onderwerp": "...", "bevinding": "...", "citaat": "art. X BW of leeg", "ernst": "laag|midden|hoog"}],
  "volledigheid": [{"sectie": "...", "status": "aanwezig|onvolledig|ontbreekt", "toelichting": "..."}],
  "balans": [{"signalering": "...", "ernst": "laag|midden|hoog"}],
  "samenvatting": "2-3 zinnen totaalindruk"
}
Wees specifiek en beknopt. Bij "volledigheid" doorloop je de volledige checklist, ook de punten die in orde zijn (status "aanwezig").
Verzin geen wetsartikelen die niet in de gegeven context staan.`,
      `DOCUMENTTEKST:\n${documentTekst}\n\nVERWACHTE SECTIES (checklist op basis van de situatie):\n${checklistTekst}\n\nRELEVANTE WETSARTIKELEN:\n${wetTekst || '(geen specifiek relevante artikelen gevonden)'}`,
      4096
    );
    const rapport = parseJsonLoosely(rapportRuw);

    return res.status(200).json({
      classificatie,
      rapport,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
