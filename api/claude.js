// Vercel serverless proxy voor Anthropic Claude API
// De ANTHROPIC_API_KEY staat in de Vercel omgevingsvariabelen, nooit in de browser-code.
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Alleen POST toegestaan' });
  }
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'ANTHROPIC_API_KEY niet geconfigureerd op de server' });
  }
  try {
    const headers = {
      'Content-Type':      'application/json',
      'x-api-key':         apiKey,
      'anthropic-version': '2023-06-01',
    };
    // Stuur prompt-caching beta-header door als de client die meestuurt
    const betaHeader = req.headers['anthropic-beta'];
    if (betaHeader) headers['anthropic-beta'] = betaHeader;

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers,
      body: JSON.stringify(req.body),
    });
    const data = await response.json();
    res.status(response.status).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
