// api/extract-pdf.js
// PDF-naar-tekst via LlamaParse (gestructureerde markdown met behoud van opmaak)
//
// POST  { filename, base64 }  → { jobId }          upload fase
// GET   ?jobId=xxx            → { status, tekst }   poll fase
//
// Vereist omgevingsvariabele: LLAMA_CLOUD_API_KEY
// Docs: https://docs.cloud.llamaindex.ai/llamaparse/getting_started/python/

const LLAMA_API = 'https://api.cloud.llamaindex.ai/api/parsing';

export default async function handler(req, res) {
  const apiKey = process.env.LLAMA_CLOUD_API_KEY;
  if (!apiKey) {
    return res.status(503).json({ error: 'LLAMA_CLOUD_API_KEY niet geconfigureerd' });
  }

  // ── GET: peil de status van een lopende job ──────────
  if (req.method === 'GET') {
    const { jobId } = req.query;
    if (!jobId) return res.status(400).json({ error: 'jobId ontbreekt' });

    try {
      const statusRes = await fetch(`${LLAMA_API}/job/${jobId}`, {
        headers: { Authorization: `Bearer ${apiKey}` },
      });
      if (!statusRes.ok) throw new Error(`Status check mislukt: ${statusRes.status}`);
      const status = await statusRes.json();

      if (status.status === 'SUCCESS') {
        // Markdown-resultaat ophalen
        const mdRes = await fetch(`${LLAMA_API}/job/${jobId}/result/markdown`, {
          headers: { Authorization: `Bearer ${apiKey}` },
        });
        if (!mdRes.ok) throw new Error(`Resultaat ophalen mislukt: ${mdRes.status}`);
        const { markdown } = await mdRes.json();
        return res.status(200).json({ status: 'SUCCESS', tekst: markdown || '' });
      }

      if (status.status === 'ERROR') {
        return res.status(200).json({ status: 'ERROR', fout: status.error || 'Onbekende fout' });
      }

      // PENDING of STARTED
      return res.status(200).json({ status: status.status || 'PENDING' });
    } catch (err) {
      return res.status(502).json({ error: err.message });
    }
  }

  // ── POST: upload PDF en start de parseer-job ─────────
  if (req.method === 'POST') {
    const { filename, base64 } = req.body || {};
    if (!base64) return res.status(400).json({ error: 'base64 ontbreekt in request body' });

    try {
      const buffer = Buffer.from(base64, 'base64');

      // FormData met het PDF-bestand + parse-instructie voor Nederlandse juridische documenten
      const form = new FormData();
      form.append(
        'file',
        new Blob([buffer], { type: 'application/pdf' }),
        filename || 'document.pdf',
      );
      form.append('language', 'nl');
      form.append(
        'parsing_instruction',
        'Dit is een Nederlands juridisch document (echtscheidingsconvenant, ouderschapsplan of bijlage). ' +
        'Behoud de volledige structuur: gebruik ## voor artikelkoppen (bijv. "## Artikel 3 — Partneralimentatie"), ' +
        '### voor sub-artikelen (bijv. "### 3.1 Ingangsdatum"), en gewone alinea\'s voor lopende tekst. ' +
        'Bewaar lijstpunten als markdown lijst. Verwijder paginakoppen en paraaf-regels. ' +
        'Behoud alle bedragen, data, namen en wetsartikelen exact zoals ze in het document staan.',
      );
      // Gebruik premium modus voor betere structuurherkenning
      form.append('premium_mode', 'true');

      const uploadRes = await fetch(`${LLAMA_API}/upload`, {
        method: 'POST',
        headers: { Authorization: `Bearer ${apiKey}` },
        body: form,
      });

      if (!uploadRes.ok) {
        const errTekst = await uploadRes.text();
        throw new Error(`Upload mislukt (${uploadRes.status}): ${errTekst}`);
      }

      const { id: jobId } = await uploadRes.json();
      return res.status(200).json({ jobId });
    } catch (err) {
      return res.status(502).json({ error: err.message });
    }
  }

  return res.status(405).json({ error: 'Methode niet toegestaan' });
}
