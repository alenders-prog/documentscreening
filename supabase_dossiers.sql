-- ══════════════════════════════════════════════════════
-- Dossiers & versies — uitvoeren in Supabase SQL-editor
-- ══════════════════════════════════════════════════════

-- 1. Dossiers-tabel
CREATE TABLE IF NOT EXISTS dossiers (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  naam       text        NOT NULL,
  partij_a   text,
  partij_b   text,
  doc_type   text,                          -- 'convenant' | 'ouderschapsplan' | 'beide'
  status     text        NOT NULL DEFAULT 'actief', -- 'actief' | 'afgerond' | 'gearchiveerd'
  notities   text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- 2. Screeningen koppelen aan dossiers
ALTER TABLE screeningen
  ADD COLUMN IF NOT EXISTS dossier_id   uuid REFERENCES dossiers(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS versie_nr    integer DEFAULT 1,
  ADD COLUMN IF NOT EXISTS versie_label text;

-- 3. Index voor snelle query per dossier
CREATE INDEX IF NOT EXISTS idx_screeningen_dossier ON screeningen(dossier_id);

-- 4. RLS: alleen ingelogde gebruikers
ALTER TABLE dossiers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS dossiers_auth ON dossiers;
CREATE POLICY dossiers_auth ON dossiers
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);
