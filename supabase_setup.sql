-- ============================================================
--  Community Business Directory — Supabase Database Setup
--  Run this in Supabase → SQL Editor → New Query → Run
-- ============================================================

-- 1. Create the businesses table
CREATE TABLE IF NOT EXISTS businesses (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_name    TEXT        NOT NULL,
  business_name TEXT        NOT NULL,
  contact       TEXT        NOT NULL UNIQUE,
  business_type TEXT        NOT NULL,
  address       TEXT        DEFAULT '',
  city          TEXT        NOT NULL,
  state         TEXT        NOT NULL,
  country       TEXT        NOT NULL,
  edit_pin      TEXT        NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Index for fast search/filter queries
CREATE INDEX IF NOT EXISTS idx_businesses_city          ON businesses (city);
CREATE INDEX IF NOT EXISTS idx_businesses_state         ON businesses (state);
CREATE INDEX IF NOT EXISTS idx_businesses_country       ON businesses (country);
CREATE INDEX IF NOT EXISTS idx_businesses_business_type ON businesses (business_type);
CREATE INDEX IF NOT EXISTS idx_businesses_contact       ON businesses (contact);

-- 3. Row Level Security — allow public read, public insert, and
--    owner can update/delete using their contact + PIN
ALTER TABLE businesses ENABLE ROW LEVEL SECURITY;

-- Allow anyone to READ listings (public directory)
CREATE POLICY "Public can read businesses"
  ON businesses FOR SELECT
  USING (true);

-- Allow anyone to INSERT (self-registration)
CREATE POLICY "Anyone can register"
  ON businesses FOR INSERT
  WITH CHECK (true);

-- Allow UPDATE only when the correct edit_pin is provided
-- (checked in app logic — policy trusts the app layer)
CREATE POLICY "Owner can update own business"
  ON businesses FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Allow DELETE (admin and owner — controlled in app logic)
CREATE POLICY "Owner or admin can delete"
  ON businesses FOR DELETE
  USING (true);

-- ============================================================
--  DONE! Your table is ready.
--  Next steps:
--  1. Copy your Supabase Project URL and anon key from:
--     Supabase Dashboard → Settings → API
--  2. Paste them in index.html at the top (SUPABASE_URL and
--     SUPABASE_ANON_KEY constants)
--  3. Change ADMIN_PASSWORD in index.html before sharing
--  4. Open index.html in a browser — done!
-- ============================================================
