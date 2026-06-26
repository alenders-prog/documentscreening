-- ══════════════════════════════════════════════════════════════════════
-- legal_chunks seed — wetsartikelen voor documentscreening
-- Stap 1: legal_sources aanmaken (bronrecord per wet)
-- Stap 2: legal_chunks invoegen met source_id + chunk_index
--
-- Uitvoeren in de Supabase SQL-editor van het Documentscreening-project
-- (zanxprrymagsuwxddiln), NIET de Scheidingskennisbank.
-- ══════════════════════════════════════════════════════════════════════

-- Opruimen (houd volgorde aan: chunks voor sources vanwege FK)
DELETE FROM legal_chunks;
DELETE FROM legal_sources;

-- ── Stap 1: Bronrecords ──────────────────────────────────────────────

INSERT INTO legal_sources (id, title, bwb_id, source_type, url, valid_from) VALUES
(
  '10000000-0000-0000-0000-000000000001',
  'Burgerlijk Wetboek Boek 1 — Personen- en familierecht',
  'BWBR0002656',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0002656',
  '1970-01-01'
),
(
  '10000000-0000-0000-0000-000000000002',
  'Wetboek van Burgerlijke Rechtsvordering',
  'BWBR0001827',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0001827',
  '1838-10-01'
),
(
  '10000000-0000-0000-0000-000000000003',
  'Wet verevening pensioenrechten bij scheiding (WVPS)',
  'BWBR0006081',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0006081',
  '1995-05-01'
),
(
  '10000000-0000-0000-0000-000000000004',
  'Burgerlijk Wetboek Boek 3 — Vermogensrecht',
  'BWBR0005291',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0005291',
  '1992-01-01'
);

-- ── Stap 2: Wetsartikelen als chunks ────────────────────────────────
-- Kolom "citation" is toegevoegd aan legal_chunks boven op het basisschema.
-- Als die kolom nog niet bestaat, voer dan eerst uit:
--   ALTER TABLE legal_chunks ADD COLUMN IF NOT EXISTS citation text;

INSERT INTO legal_chunks (source_id, chunk_index, citation, content, topic_tags) VALUES

-- ── BW Boek 1 ────────────────────────────────────────────────────────

('10000000-0000-0000-0000-000000000001', 1,
'art. 1:157 BW',
'De rechter kan op verzoek van één der echtgenoten bij de echtscheidingsbeschikking of bij latere uitspraak bepalen dat de ene echtgenoot verplicht is de andere uitkering tot levensonderhoud (partneralimentatie) te verstrekken. De alimentatieverplichting eindigt na verloop van een periode gelijk aan de helft van de duur van het huwelijk, met een maximum van twaalf jaar. Dat maximum geldt niet als het huwelijk langer dan vijftien jaar heeft geduurd én de onderhoudsgerechtigde binnen tien jaar de pensioengerechtigde leeftijd bereikt.',
ARRAY['partneralimentatie','alimentatie','convenant']),

('10000000-0000-0000-0000-000000000001', 2,
'art. 1:158 BW',
'Echtgenoten kunnen bij overeenkomst, ook staande huwelijk, het recht op levensonderhoud na echtscheiding uitsluiten of beperken. Een zodanige overeenkomst verliest haar kracht niet doordat de omstandigheden wijzigen. Dit is de grondslag voor het nihilbeding in een convenant.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('10000000-0000-0000-0000-000000000001', 3,
'art. 1:159 BW',
'Indien de echtgenoten bij overeenkomst levensonderhoud hebben uitgesloten (nihilbeding) of beperkt, kan de rechter op verzoek de overeenkomst wijzigen als ongewijzigde instandhouding naar maatstaven van redelijkheid en billijkheid niet kan worden gevergd. Een nihilbeding is alleen rechtsgeldig als beide partijen er bewust en geïnformeerd mee hebben ingestemd; de mediator dient dit te documenteren.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('10000000-0000-0000-0000-000000000001', 4,
'art. 1:404 BW',
'Ouders zijn verplicht naar draagkracht te voorzien in de kosten van verzorging en opvoeding van hun minderjarige kinderen. De behoefte van het kind wordt vastgesteld aan de hand van de Tremanormen (richtlijn van de Expertgroep Alimentatienormen). Een afwijking van de Tremanormen dient expliciet gemotiveerd te worden in het convenant of ouderschapsplan.',
ARRAY['kinderalimentatie','alimentatie','ouderschapsplan','convenant','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 5,
'art. 1:94 BW',
'De huwelijksgemeenschap omvat alle tegenwoordige en toekomstige goederen der echtgenoten, met uitzondering van goederen die buiten de gemeenschap vallen door huwelijkse voorwaarden of door gift/erfenis met uitsluitingsclausule. Het convenant dient specifiek te regelen welke goederen tot de gemeenschap behoren en hoe de verdeling of verrekening plaatsvindt.',
ARRAY['vermogen','verdeling','gemeenschap_van_goederen','huwelijk_voor_2018','convenant']),

('10000000-0000-0000-0000-000000000001', 6,
'art. 1:121 BW',
'Indien een verrekenbeding in huwelijkse voorwaarden niet of niet volledig is nageleefd, worden aan het einde van het huwelijk de op dat moment aanwezige vermogens als te verrekenen vermogen aangemerkt, tenzij uit de huwelijkse voorwaarden anders voortvloeit. Het convenant dient te bevestigen of verrekenbedingen zijn nagekomen of anderszins zijn afgewikkeld.',
ARRAY['huwelijkse_voorwaarden','vermogen','convenant']),

('10000000-0000-0000-0000-000000000001', 7,
'art. 1:247 BW',
'Het ouderlijk gezag omvat de plicht en het recht van de ouder zijn minderjarig kind te verzorgen en op te voeden, alsmede het bewind over zijn vermogen. Ouders behouden na echtscheiding gezamenlijk het ouderlijk gezag tenzij de rechter anders bepaalt op verzoek van één of beide ouders. Het ouderschapsplan dient te bevestigen dat het gezamenlijk gezag gecontinueerd wordt, of moet vermelden waarom eenhoofdig gezag wordt gevraagd.',
ARRAY['gezag','ouderschapsplan','gezamenlijk_gezag','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 8,
'art. 1:377b BW',
'De ouder bij wie het kind niet zijn hoofdverblijfplaats heeft, heeft het recht op en de verplichting tot omgang met het kind. De andere ouder is gehouden de omgang mogelijk te maken en is verplicht de andere ouder te informeren over gewichtige aangelegenheden de persoon en het vermogen van het kind betreffende. In het ouderschapsplan dient de informatie- en consultatieverplichting expliciet te worden opgenomen.',
ARRAY['omgang','informatieplicht','ouderschapsplan','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 9,
'art. 1:253a BW',
'In geval van gezamenlijk gezag na scheiding kunnen ouders bij geschillen over de gezamenlijke uitoefening de rechter verzoeken een regeling te treffen. Het ouderschapsplan doet er verstandig aan een mediationclausule of escalatiebepaling op te nemen voor het geval partijen het in de toekomst niet eens worden over de uitvoering.',
ARRAY['geschillenregeling','ouderschapsplan','gezag','kinderen_minderjarig']),

-- ── Wetboek van Burgerlijke Rechtsvordering ──────────────────────────

('10000000-0000-0000-0000-000000000002', 1,
'art. 815 Rv',
'Een verzoekschrift tot echtscheiding ingediend door beide echtgenoten gaat vergezeld van een door hen ondertekend convenant. Dit convenant regelt ten minste: de verdeling van de huwelijksgemeenschap of de verrekening van het vermogen, de partneralimentatie, de pensioenverevening en de verdeling of het gebruik van de woning. Een incompleet convenant kan door de rechter worden teruggestuurd.',
ARRAY['convenant','volledigheid','pensioen','alimentatie','woning']),

('10000000-0000-0000-0000-000000000002', 2,
'art. 826 Rv',
'Bij een verzoekschrift tot echtscheiding waarbij minderjarige kinderen zijn betrokken, wordt een door de echtgenoten ondertekend ouderschapsplan gevoegd. Dit plan bevat ten minste: (a) de verdeling van de zorg- en opvoedingstaken (zorgregeling), (b) de wijze waarop de ouders elkaar informeren en raadplegen over de kinderen, (c) de kosten van verzorging en opvoeding. Het ontbreken van één van deze drie onderdelen is een formeel gebrek.',
ARRAY['ouderschapsplan','zorgregeling','informatieplicht','kinderalimentatie','kinderen_minderjarig']),

-- ── WVPS ─────────────────────────────────────────────────────────────

('10000000-0000-0000-0000-000000000003', 1,
'WVPS art. 2',
'De gewezen echtgenoot heeft recht op verevening van het ouderdomspensioen dat de andere gewezen echtgenoot heeft opgebouwd tijdens het huwelijk. De standaard-vereveningsfractie is 50% van het tijdens het huwelijk opgebouwde pensioen. Dit recht geldt automatisch bij echtscheiding, tenzij partijen schriftelijk een andere regeling overeenkomen (WVPS art. 5). Zonder expliciete bepaling in het convenant geldt de wettelijke 50/50-verevening.',
ARRAY['pensioen','pensioenverevening','convenant']),

('10000000-0000-0000-0000-000000000003', 2,
'WVPS art. 5',
'Partijen kunnen schriftelijk overeenkomen af te wijken van de standaard pensioenverevening (WVPS art. 2). Mogelijke afwijkingen: een andere verdeling dan 50/50, conversie (omzetting in een eigen zelfstandig pensioenrecht), of volledige afstand van vereveningsaanspraken. Een afwijkingsovereenkomst dient uitdrukkelijk schriftelijk te worden vastgelegd in het convenant. Zonder schriftelijke afwijking geldt automatisch de wettelijke verevening.',
ARRAY['pensioen','pensioenverevening','pensioenverevening_uitgesloten','convenant']),

-- ── BW Boek 3 ────────────────────────────────────────────────────────

('10000000-0000-0000-0000-000000000004', 1,
'art. 3:170 BW',
'Deelgenoten zijn slechts bevoegd tot beheers- en beschikkingshandelingen over gemeenschappelijk goed indien allen daartoe besluiten. Bij verdeling van een gezamenlijk koophuis moeten beide partijen instemmen met verkoop of toedeling. Het convenant dient te regelen: (1) wie de woning overneemt of dat de woning wordt verkocht, (2) de peildatum voor de waardebepaling, (3) wanneer de overdracht bij de notaris plaatsvindt, en (4) of de andere partij wordt ontslagen uit hoofdelijke aansprakelijkheid voor de hypotheek.',
ARRAY['woning','hypotheek','verdeling','eigen_woning','convenant']);

-- ── Controleer resultaat ─────────────────────────────────────────────
SELECT ls.title, lc.citation, lc.topic_tags
FROM legal_chunks lc
JOIN legal_sources ls ON ls.id = lc.source_id
ORDER BY lc.source_id, lc.chunk_index;
