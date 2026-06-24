import { createClient } from '@supabase/supabase-js';
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

export default async function handler(req, res) {
  try {
    const { id } = req.query;
    if (!id) return res.status(400).json({ error: 'id is verplicht' });

    if (req.method === 'GET') {
      const { data, error } = await supabase.from('screeningen').select('*').eq('id', id).single();
      if (error) throw error;
      return res.status(200).json(data);
    }

    if (req.method === 'DELETE') {
      const { error } = await supabase.from('screeningen').delete().eq('id', id);
      if (error) throw error;
      return res.status(200).json({ verwijderd: true });
    }

    return res.status(405).json({ error: 'Alleen GET of DELETE' });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
