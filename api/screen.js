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

async function askClaudeForJson(systemPrompt, userPrompt, tool, maxTokens = 4096) {
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
      tools: [tool],
      tool_choice: { type: 'tool', name: tool.name },
    }),
  });
  if (!res.ok) throw new Error(`Claude API fout (${res.status}): ${await res.text()}`);
  const json = await res.json();
  const toolUse = json.content.find((b) => b.type === 'tool_use');
  if (!toolUse) throw new Error('Claude gaf geen tool-aanroep terug — onverwacht antwoordformaat.');
  return toolUse.input; // al een geparsed object, geen JSON.parse nodig
}

const classificatieTool = {
  name: 'classificeer_document',
  description: 'Registreert de classificatie van een echtscheidingsdocument.',
  input_schema: {
    type: 'object',
    properties: {
      doc_type: { type: 'string', enum: ['convenant', 'ouderschapsplan', 'onbekend'] },
      situatie_kenmerken: { type: 'array', items: { type: 'string' } },
      partij_a_naam: { type: 'string', description: 'Voor- en achternaam van de eerste partij ("de man" of vergelijkbaar), zoals genoemd in het document. Leeg laten als dit niet te vinden is.' },
      partij_b_naam: { type: 'string', description: 'Voor- en achternaam van de tweede partij ("de vrouw" of vergelijkbaar), zoals genoemd in het document. Leeg laten als dit niet te vinden is.' },
      samenvatting: { type: 'string' },
    },
    required: ['doc_type', 'situatie_kenmerken', 'partij_a_naam', 'partij_b_naam', 'samenvatting'],
  },
};

const rapportTool = {
  name: 'registreer_rapport',
  description: 'Registreert het screeningsrapport van een echtscheidingsdocument.',
  input_schema: {
    type: 'object',
    properties: {
      grammatica: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            locatie: { type: 'string' },
            probleem: { type: 'string' },
            suggestie: { type: 'string' },
          },
          required: ['locatie', 'probleem', 'suggestie'],
        },
      },
      juridisch: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            onderwerp: { type: 'string' },
            bevinding: { type: 'string' },
            citaat: { type: 'string' },
            ernst: { type: 'string', enum: ['laag', 'midden', 'hoog'] },
          },
          required: ['onderwerp', 'bevinding', 'ernst'],
        },
      },
      volledigheid: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            sectie: { type: 'string' },
            status: { type: 'string', enum: ['aanwezig', 'onvolledig', 'ontbreekt'] },
            toelichting: { type: 'string' },
          },
          required: ['sectie', 'status', 'toelichting'],
        },
      },
      balans: {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            signalering: { type: 'string' },
            ernst: { type: 'string', enum: ['laag', 'midden', 'hoog'] },
          },
          required: ['signalering', 'ernst'],
        },
      },
      samenvatting: { type: 'string' },
    },
    required: ['grammatica', 'juridisch', 'volledigheid', 'balans', 'samenvatting'],
  },
};

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

    const classificatie = await askClaudeForJson(
      `Je classificeert een Nederlands echtscheidingsdocument en haalt de namen van beide partijen eruit.
Gebruik voor situatie_kenmerken UITSLUITEND keys uit deze lijst: ${kenmerkenLijst}`,
      documentTekst.slice(0, 6000),
      classificatieTool,
      1024
    );

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

    const rapport = await askClaudeForJson(
      `Je bent een ervaren familiemediator die een al opgesteld echtscheidingsdocument controleert.
Wees specifiek en beknopt. Bij "volledigheid" doorloop je de volledige checklist, ook de punten die in orde zijn (status "aanwezig").
Verzin geen wetsartikelen die niet in de gegeven context staan; laat "citaat" dan leeg.`,
      `DOCUMENTTEKST:\n${documentTekst}\n\nVERWACHTE SECTIES (checklist op basis van de situatie):\n${checklistTekst}\n\nRELEVANTE WETSARTIKELEN:\n${wetTekst || '(geen specifiek relevante artikelen gevonden)'}`,
      rapportTool,
      8192
    );

    return res.status(200).json({
      classificatie,
      rapport,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
