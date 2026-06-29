// Vercel serverless proxy voor Anthropic Claude API
// De ANTHROPIC_API_KEY staat in de Vercel omgevingsvariabelen, nooit in de browser-code.

import https from 'https';

export const config = {
  api: { bodyParser: { sizeLimit: '12mb' } },
};

// Gebruikt https.request() in plaats van fetch() om Vercel/undici headersTimeout te omzeilen.
function anthropicPost(headers, body) {
  return new Promise((resolve, reject) => {
    const payload = JSON.stringify(body);
    const req = https.request({
      hostname: 'api.anthropic.com',
      path:     '/v1/messages',
      method:   'POST',
      headers: { ...headers, 'Content-Length': Buffer.byteLength(payload) },
      timeout: 115_000,
    }, (res) => {
      let data = '';
      res.on('data', chunk => (data += chunk));
      res.on('end', () => {
        try { resolve({ status: res.statusCode, json: JSON.parse(data) }); }
        catch (e) { reject(new Error(`JSON-parse mislukt: ${data.slice(0, 200)}`)); }
      });
    });
    req.on('error',   reject);
    req.on('timeout', () => { req.destroy(); reject(new Error('Anthropic API timeout')); });
    req.write(payload);
    req.end();
  });
}

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

    const { status, json } = await anthropicPost(headers, req.body);
    res.status(status).json(json);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
