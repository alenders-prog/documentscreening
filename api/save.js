import { createClient } from '@supabase/supabase-js';
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY);

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Alleen POST' });
  try {
    const { id, bestandsnaam, classificatie, rapport } = req.body;
    if (!classificatie || !rapport) return res.status(400).json({ error: 'classificatie en rapport zijn verplicht' });

    if (id) {
      const { data, error } = await supabase
        .from('screeningen')
        .update({ classificatie, rapport, updated_at: new Date().toISOString() })
        .eq('id', id)
        .select('id')
        .single();
      if (error) throw error;
      return res.status(200).json({ id: data.id });
    }

    const { data, error } = await supabase
      .from('screeningen')
      .insert({ bestandsnaam, classificatie, rapport })
      .select('id')
      .single();
    if (error) throw error;
    return res.status(200).json({ id: data.id });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
