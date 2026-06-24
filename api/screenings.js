import { createClient } from '@supabase/supabase-js';
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

export default async function handler(req, res) {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Alleen GET' });
  try {
    const { data, error } = await supabase
      .from('screeningen')
      .select('id, bestandsnaam, classificatie, created_at, updated_at')
      .order('updated_at', { ascending: false })
      .limit(200);
    if (error) throw error;
    return res.status(200).json({ screeningen: data });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
