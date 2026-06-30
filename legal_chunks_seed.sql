-- ══════════════════════════════════════════════════════════════════════
-- legal_chunks seed — wetsartikelen voor documentscreening
-- Stap 1: legal_sources aanmaken (bronrecord per wet)
-- Stap 2: legal_chunks invoegen met source_id + chunk_index
--
-- Uitvoeren in de Supabase SQL-editor van het Documentscreening-project
-- (zanxprrymagsuwxddiln), NIET de Scheidingskennisbank.
--
-- Versie: 2026-06 — uitgebreid met IB 2001, Participatiewet,
--   art. 1:159a, 1:160, 1:397, 1:401, 1:402, 1:408, 1:253n,
--   1:377a, 1:94 (2018), 1:99-100, WVPS art. 11
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
),
(
  '10000000-0000-0000-0000-000000000006',
  'Wet inkomstenbelasting 2001',
  'BWBR0011353',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0011353',
  '2001-01-01'
),
(
  '10000000-0000-0000-0000-000000000007',
  'Participatiewet',
  'BWBR0015703',
  'wetboek',
  'https://wetten.overheid.nl/BWBR0015703',
  '2015-01-01'
);

-- ── Stap 2: Wetsartikelen als chunks ────────────────────────────────

INSERT INTO legal_chunks (source_id, chunk_index, citation, content, topic_tags) VALUES

-- ════════════════════════════════════════════════════════════════════
-- BW BOEK 1 — PERSONEN- EN FAMILIERECHT
-- ════════════════════════════════════════════════════════════════════

-- ── Huwelijksvermogen ────────────────────────────────────────────────

('10000000-0000-0000-0000-000000000001', 1,
'art. 1:94 BW (vóór 1-1-2018) — algehele gemeenschap van goederen',
'Voor huwelijken gesloten VOOR 1 januari 2018 geldt als wettelijk standaardstelsel de ALGEHELE gemeenschap van goederen. De huwelijksgemeenschap omvat alle tegenwoordige en toekomstige goederen van beide echtgenoten, inclusief schulden. Uitzondering: goederen verkregen krachtens erfopvolging of schenking met uitsluitingsclausule (art. 1:94 lid 3 oud BW / art. 1:95 BW). Het convenant dient specifiek te regelen welke goederen tot de gemeenschap behoren en hoe de verdeling of verrekening plaatsvindt. Controleer huwelijksdatum: vóór 2018 → algehele gemeenschap tenzij huwelijkse voorwaarden.',
ARRAY['vermogen','verdeling','gemeenschap_van_goederen','huwelijk_voor_2018','convenant']),

('10000000-0000-0000-0000-000000000001', 2,
'art. 1:94 BW (na 1-1-2018) — beperkte gemeenschap van goederen',
'Voor huwelijken gesloten OP OF NA 1 januari 2018 geldt als wettelijk standaardstelsel de BEPERKTE gemeenschap van goederen (Wet beperking gemeenschap van goederen, Stb. 2017, 177). Buiten de gemeenschap vallen: (a) vermogen dat vóór het huwelijk al aanwezig was (aangebracht vermogen), (b) verkrijgingen krachtens erfopvolging of schenking tijdens het huwelijk, ook zonder uitsluitingsclausule. Binnen de gemeenschap valt: wat tijdens het huwelijk gezamenlijk is opgebouwd of aangeschaft. Het convenant dient bij huwelijken na 2018: (1) aan te geven welk stelsel van toepassing is; (2) het aangebrachte eigen vermogen te specificeren (beginstaat); (3) uitdrukkelijk te regelen hoe gezamenlijk opgebouwd vermogen wordt verdeeld. Let op: als er huwelijkse voorwaarden zijn, gaat die regeling voor boven het wettelijk standaardstelsel.',
ARRAY['vermogen','verdeling','beperkte_gemeenschap','huwelijk_na_2018','convenant','huwelijkse_voorwaarden']),

('10000000-0000-0000-0000-000000000001', 3,
'art. 1:99–100 BW — ontbinding en verdeling huwelijksgemeenschap',
'Art. 1:99 BW: De huwelijksgemeenschap wordt ontbonden door (a) echtscheiding, (b) scheiding van tafel en bed, (c) het aangaan van huwelijkse voorwaarden, of (d) overlijden. Peildatum voor de omvang: datum ontbinding (tenzij partijen een andere peildatum overeenkomen). Art. 1:100 BW: Iedere echtgenoot heeft recht op de helft van het saldo van de gemeenschap, tenzij de echtgenoten bij huwelijkse voorwaarden anders zijn overeengekomen. Van de wettelijke 50/50-verdeling kan in het convenant worden afgeweken, mits schriftelijk vastgelegd. Aandachtspunten voor convenant: (1) peildatum voor waardebepaling goederen en schulden; (2) welke goederen worden toebedeeld aan wie; (3) eventuele overbedeling en onderbedeling; (4) vergoedingsrechten (art. 1:95 BW) voor aangebracht eigen vermogen.',
ARRAY['vermogen','verdeling','gemeenschap_van_goederen','beperkte_gemeenschap','convenant']),

('10000000-0000-0000-0000-000000000001', 4,
'art. 1:114 BW — huwelijkse voorwaarden',
'Echtgenoten kunnen zowel vóór als tijdens het huwelijk bij notariële akte huwelijkse voorwaarden maken of wijzigen. De huwelijkse voorwaarden bepalen het vermogensrechtelijk stelsel dat van toepassing is. Drie hoofdstelsels: (1) algehele gemeenschap van goederen (vóór 2018 standaard), (2) beperkte gemeenschap (na 1-1-2018 standaard), (3) volledige uitsluiting (koude uitsluiting) of stelsel met verrekenbeding. Bij scheiding dient het convenant expliciet naar de huwelijkse voorwaarden te verwijzen (datum en notaris).',
ARRAY['huwelijkse_voorwaarden','vermogen','convenant']),

('10000000-0000-0000-0000-000000000001', 5,
'art. 1:132–133 BW — koude uitsluiting',
'Koude uitsluiting houdt in dat echtgenoten élke gemeenschap van goederen uitsluiten zonder een verrekenbeding overeen te komen. Elk der echtgenoten houdt zijn eigen vermogen; wat gezamenlijk is aangeschaft of gefinancierd, is niet automatisch gezamenlijk eigendom. Bij scheiding na koude uitsluiting dient het convenant: (1) expliciet te bevestigen dat geen gemeenschap bestaat; (2) gezamenlijk gehouden goederen (woning, bankrekeningen) afzonderlijk te verdelen; (3) niet de term "verdeling huwelijksgemeenschap" te gebruiken — dit is feitelijk onjuist en kan verwarring scheppen bij de notaris. Pensioenverevening geldt onveranderd ook bij koude uitsluiting (WVPS).',
ARRAY['huwelijkse_voorwaarden','koude_uitsluiting','vermogen','convenant']),

('10000000-0000-0000-0000-000000000001', 6,
'art. 1:121 BW — verrekenbeding',
'Indien een verrekenbeding in huwelijkse voorwaarden niet of niet volledig is nageleefd, worden aan het einde van het huwelijk de op dat moment aanwezige vermogens als te verrekenen vermogen aangemerkt, tenzij uit de huwelijkse voorwaarden anders voortvloeit. Het convenant dient te bevestigen of verrekenbedingen zijn nagekomen of anderszins zijn afgewikkeld.',
ARRAY['huwelijkse_voorwaarden','verrekenbeding','vermogen','convenant']),

('10000000-0000-0000-0000-000000000001', 7,
'art. 1:141 BW — niet-nagekomen periodiek verrekenbeding',
'Indien een periodiek verrekenbeding in de huwelijkse voorwaarden niet of niet volledig is nagekomen gedurende het huwelijk, worden op grond van art. 1:141 lid 3 BW alle op dat moment aanwezige goederen vermoed te zijn gevormd uit hetgeen verrekend had moeten worden (het "anti-speculatiebeding"). Dit vermoeden is weerlegbaar maar de bewijslast ligt bij de partij die stelt dat een goed niet uit te verrekenen inkomsten stamt. Het convenant dient: (1) vast te stellen of het periodiek verrekenbeding is nagekomen; (2) zo nee: een finale verrekening op te nemen of expliciet af te zien van verrekeningsaanspraken (kwijtschelding); (3) zo nodig een peildatum en methode voor de berekening te vermelden.',
ARRAY['huwelijkse_voorwaarden','verrekenbeding','vermogen','convenant']),

('10000000-0000-0000-0000-000000000001', 8,
'art. 1:94 lid 3 BW / art. 1:95 BW — uitsluitingsclausule en zaaksvervanging',
'Goederen die krachtens erfopvolging of schenking worden verkregen met een uitsluitingsclausule vallen buiten de huwelijksgemeenschap of buiten de verrekenplicht, ook als ze later worden vervangen (zaaksvervanging, art. 1:95 BW). Let op: bij huwelijken na 1-1-2018 geldt dit automatisch voor erfenissen en schenkingen, ook zonder uitsluitingsclausule (art. 1:94 nieuw). In het convenant dient te worden vastgesteld: (1) of een der partijen goederen heeft ontvangen onder uitsluitingsclausule of via erfenis/schenking na 2018; (2) of deze goederen correct buiten de vermogensafwikkeling zijn gebleven; (3) of er vermengd is met gemeenschapsgoederen en zo ja, hoe dat wordt verrekend.',
ARRAY['huwelijkse_voorwaarden','uitsluitingsclausule','vermogen','convenant']),

-- ── Partneralimentatie ───────────────────────────────────────────────

('10000000-0000-0000-0000-000000000001', 9,
'art. 1:157 BW — recht op en duur partneralimentatie',
'De rechter kan op verzoek van één der echtgenoten bij de echtscheidingsbeschikking of bij latere uitspraak bepalen dat de ene echtgenoot verplicht is de andere uitkering tot levensonderhoud (partneralimentatie) te verstrekken. Duur (Wet herziening partneralimentatie, inwerkingtreding 1-1-2020): de alimentatieverplichting eindigt na een periode gelijk aan de helft van de duur van het huwelijk, met een maximum van vijf jaar. Uitzondering 1: als er kinderen zijn (tot jongste kind 12 jaar), is de duur minimaal de tijd totdat het jongste kind 12 jaar is, maar maximaal 12 jaar. Uitzondering 2: bij huwelijken van 15 jaar of langer waarbij de onderhoudsgerechtigde binnen 10 jaar de AOW-leeftijd bereikt: maximaal tot de AOW-leeftijd van de onderhoudsgerechtigde. Convenant: dient ingangsdatum, hoogte en einddatum te vermelden, of een nihilbeding (art. 1:158 BW).',
ARRAY['partneralimentatie','alimentatie','convenant']),

('10000000-0000-0000-0000-000000000001', 10,
'art. 1:158 BW — nihilbeding partneralimentatie',
'Echtgenoten kunnen bij overeenkomst, ook staande huwelijk, het recht op levensonderhoud na echtscheiding uitsluiten of beperken. Een zodanige overeenkomst verliest haar kracht niet doordat de omstandigheden wijzigen. Dit is de grondslag voor het nihilbeding in een convenant. Vereiste voor geldigheid nihilbeding: beide partijen moeten bewust en geïnformeerd hebben ingestemd; de mediator dient dit te documenteren (informed consent). Combineer met art. 1:159a BW: een rechtsgeldig nihilbeding beschermt ook jegens de gemeente (Participatiewet).',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('10000000-0000-0000-0000-000000000001', 11,
'art. 1:159 BW — wijziging nihilbeding',
'Indien de echtgenoten bij overeenkomst levensonderhoud hebben uitgesloten (nihilbeding) of beperkt, kan de rechter op verzoek de overeenkomst wijzigen als ongewijzigde instandhouding naar maatstaven van redelijkheid en billijkheid niet kan worden gevergd. Een nihilbeding is alleen rechtsgeldig als beide partijen er bewust en geïnformeerd mee hebben ingestemd; de mediator dient dit te documenteren.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('10000000-0000-0000-0000-000000000001', 12,
'art. 1:159a BW — nihilbeding geldig jegens gemeente (Participatiewet)',
'Art. 1:159a BW (in werking getreden 1 januari 2012): Een overeenkomst als bedoeld in artikel 158 waarbij het recht op levensonderhoud is uitgesloten (nihilbeding), is ook geldig jegens de gemeente die op grond van de Participatiewet verhaal zoekt op de onderhoudsplichtige. Achtergrond: zonder dit artikel zou de gemeente via art. 62 Participatiewet het nihilbeding kunnen negeren en toch verhaal nemen op de ex-partner. Art. 1:159a BW maakt het nihilbeding dus ook "derdenwerking" effectief. Praktisch belang voor convenant: (1) Als er een nihilbeding is, is art. 1:159a BW het wettelijk fundament dat dit beding ook beschermt als de onderhoudsgerechtigde in de bijstand belandt; (2) Het nihilbeding moet wél rechtsgeldig zijn (art. 1:158 BW) — dus informed consent gedocumenteerd; (3) Dit artikel is bestaand recht en geldig — niet verwarren met "niet-bestaand"; (4) Als het convenant geen nihilbeding bevat maar wel partneralimentatie op nihil stelt, is expliciete verwijzing naar art. 1:158 jo. 1:159a BW sterk aan te bevelen.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant','participatiewet']),

('10000000-0000-0000-0000-000000000001', 13,
'art. 1:160 BW — verval alimentatie bij samenwonen of hertrouwen',
'De verplichting tot partneralimentatie eindigt van rechtswege wanneer de onderhoudsgerechtigde: (a) hertrouwt, (b) een geregistreerd partnerschap aangaat, of (c) is gaan samenwonen met een ander als waren zij gehuwd of als hadden zij hun partnerschap laten registreren. "Samenwonen als ware gehuwd" is een feitelijk begrip: er moet sprake zijn van duurzame samenleving met wederzijdse verzorging en een gemeenschappelijke huishouding. De alimentatieplichtige draagt de bewijslast. Convenant: partijen kunnen aanvullende afspraken maken over informatieverplichting bij nieuwe relatie. Let op: na verval op grond van art. 1:160 BW herleeft de alimentatieplicht niet, ook niet als de nieuwe relatie eindigt.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('10000000-0000-0000-0000-000000000001', 14,
'art. 1:397 BW — draagkracht alimentatie (algemeen)',
'Iedere bloed- of aanverwant in de rechte lijn en de echtgenoot of geregistreerd partner is verplicht naar vermogen levensonderhoud te verstrekken. "Naar vermogen" betekent: de onderhoudsplichtige hoeft niet meer te betalen dan hij redelijkerwijs kan dragen, nadat zijn eigen noodzakelijke lasten zijn voldaan. Dit is de wettelijke basis voor de draagkrachtberekening in de Tremanormen. Praktisch: de draagkrachttabel houdt rekening met de bijstandsnorm (minimum bestaansnorm); niemand hoeft onder het bijstandsniveau te zakken door alimentatie te betalen. Convenant: als in het convenant een alimentatiebedrag wordt afgesproken dat afwijkt van de Tremanormen-berekening, dient dit expliciet gemotiveerd te worden (bv. "partijen wijken bewust af van de Tremanormen en stellen de bijdrage vast op €... per maand").',
ARRAY['alimentatie','partneralimentatie','kinderalimentatie','tremanormen','convenant']),

('10000000-0000-0000-0000-000000000001', 15,
'art. 1:401 BW — wijziging en intrekking alimentatie',
'Een rechterlijke uitspraak of overeenkomst betreffende levensonderhoud kan op verzoek van één der partijen worden gewijzigd of ingetrokken, wanneer zij door een wijziging van omstandigheden ophoudt aan de wettelijke maatstaven te voldoen. Gronden voor wijziging: inkomenswijziging, verlies van baan, arbeidsongeschiktheid, nieuwe leefsituatie. Dwingend recht: een beding in het convenant dat wijziging uitsluit of beperkt is in principe nietig (art. 1:400 lid 2 BW). Convenant kan wel een mededelingsplicht opnemen: partijen informeren elkaar jaarlijks over inkomensontwikkelingen. Na 3 jaar geldt een vervalbeding voor terugwerkende kracht tenzij partijen anders afspreken.',
ARRAY['alimentatie','partneralimentatie','kinderalimentatie','convenant']),

('10000000-0000-0000-0000-000000000001', 16,
'art. 1:402 BW — ingangsdatum alimentatieverplichting',
'De rechter die een uitkering tot levensonderhoud vaststelt, bepaalt met ingang van welke dag de verplichting bestaat. In het geval van partneralimentatie vastgesteld bij de echtscheidingsbeschikking: de verplichting gaat in op de dag van inschrijving van de beschikking in het register van burgerlijke stand. Partijen kunnen in het convenant een eerdere ingangsdatum overeenkomen (bv. de datum van feitelijke scheiding of de datum van ondertekening van het convenant). Belang: een convenant zonder ingangsdatum kan discussie opleveren over eventuele achterstallige betalingen. Aandachtspunten: (1) Is de ingangsdatum vermeld? (2) Begint de alimentatie pas bij inschrijving echtscheiding, of eerder? (3) Is een eventuele voorlopige voorziening verrekend?',
ARRAY['alimentatie','partneralimentatie','kinderalimentatie','convenant']),

('10000000-0000-0000-0000-000000000001', 17,
'art. 1:408 BW — indexering alimentatie',
'De krachtens overeenkomst of rechterlijke uitspraak vastgestelde bedragen voor partneralimentatie en kinderalimentatie worden jaarlijks per 1 januari geïndexeerd overeenkomstig het procentuele verschil van het CBS-indexcijfer CAO-lonen voor particuliere bedrijven (of een ander wettelijk aangewezen indexcijfer). Indexering geldt automatisch van rechtswege, tenzij bij overeenkomst of rechterlijke uitspraak anders is bepaald. Convenant: (1) bevestig de jaarlijkse indexering per 1 januari; (2) of sluit indexering uit met expliciete vermelding en motivering; (3) vermeld het CBS-indexcijfer dat wordt gehanteerd. Praktisch: als het convenant geen indexering noemt, geldt de wettelijke indexering automatisch — dit is dan geen tekortkoming maar wettelijk recht.',
ARRAY['alimentatie','partneralimentatie','kinderalimentatie','convenant']),

-- ── Kinderalimentatie ────────────────────────────────────────────────

('10000000-0000-0000-0000-000000000001', 18,
'art. 1:404 BW — kinderalimentatie',
'Ouders zijn verplicht naar draagkracht te voorzien in de kosten van verzorging en opvoeding van hun minderjarige kinderen. De behoefte van het kind wordt vastgesteld aan de hand van de Tremanormen (richtlijn van de Expertgroep Alimentatienormen). Een afwijking van de Tremanormen dient expliciet gemotiveerd te worden in het convenant of ouderschapsplan. De verplichting loopt totdat het kind 18 jaar is; daarna geldt art. 1:395a BW (jongmeerderjarigen tot 21 jaar). Kinderalimentatie is NIET fiscaal aftrekbaar voor de betaler en NIET belast bij de ontvanger (in tegenstelling tot partneralimentatie).',
ARRAY['kinderalimentatie','alimentatie','ouderschapsplan','convenant','kinderen_minderjarig']),

-- ── Ouderlijk gezag en zorgregeling ─────────────────────────────────

('10000000-0000-0000-0000-000000000001', 19,
'art. 1:247 BW — ouderlijk gezag',
'Het ouderlijk gezag omvat de plicht en het recht van de ouder zijn minderjarig kind te verzorgen en op te voeden, alsmede het bewind over zijn vermogen. Ouders behouden na echtscheiding gezamenlijk het ouderlijk gezag tenzij de rechter anders bepaalt op verzoek van één of beide ouders. Het ouderschapsplan dient te bevestigen dat het gezamenlijk gezag gecontinueerd wordt, of moet vermelden waarom eenhoofdig gezag wordt gevraagd.',
ARRAY['gezag','ouderschapsplan','gezamenlijk_gezag','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 20,
'art. 1:253n BW — eenhoofdig gezag na scheiding',
'Na echtscheiding kunnen ouders gezamenlijk of één van hen de rechter verzoeken het gezamenlijk gezag te wijzigen in eenhoofdig gezag. Gronden: (a) onaanvaardbaar risico dat het kind klem of verloren raakt tussen de ouders, (b) wijziging van omstandigheden is anderszins in het belang van het kind. Bij eenhoofdig gezag vervalt de gezagsbevoegdheid van de andere ouder, maar het omgangsrecht (art. 1:377a BW) en de alimentatieplicht (art. 1:404 BW) blijven bestaan. Convenant/ouderschapsplan: als gezamenlijk gezag bedoeld is (standaard), dient dit bevestigd te worden. Als eenhoofdig gezag gewenst is, dient dit expliciet vermeld en bij de rechtbank verzocht te worden — het kan NIET uitsluitend in een convenant worden geregeld (rechter beslist).',
ARRAY['gezag','ouderschapsplan','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 21,
'art. 1:253a BW — geschillenregeling bij gezamenlijk gezag',
'In geval van gezamenlijk gezag na scheiding kunnen ouders bij geschillen over de gezamenlijke uitoefening de rechter verzoeken een regeling te treffen. Het ouderschapsplan doet er verstandig aan een mediationclausule of escalatiebepaling op te nemen voor het geval partijen het in de toekomst niet eens worden over de uitvoering.',
ARRAY['geschillenregeling','ouderschapsplan','gezag','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000001', 22,
'art. 1:377a–377b BW — omgang en informatieplicht',
'Art. 1:377a BW: Het kind heeft recht op omgang met beide ouders. De niet-verzorgende ouder heeft het recht op en de verplichting tot omgang. De rechter stelt een omgangsregeling vast tenzij dit strijdig is met zwaarwegende belangen van het kind. Art. 1:377b BW: De ouder bij wie het kind zijn hoofdverblijfplaats heeft, is verplicht de andere ouder te informeren over gewichtige aangelegenheden de persoon en het vermogen van het kind betreffende. Tevens is overleg (consultatie) verplicht bij belangrijke beslissingen over het kind. In het ouderschapsplan dient de informatie- en consultatieverplichting expliciet te worden opgenomen (vereiste op grond van art. 826 Rv).',
ARRAY['omgang','informatieplicht','ouderschapsplan','kinderen_minderjarig']),

-- ════════════════════════════════════════════════════════════════════
-- WETBOEK VAN BURGERLIJKE RECHTSVORDERING
-- ════════════════════════════════════════════════════════════════════

('10000000-0000-0000-0000-000000000002', 1,
'art. 815 Rv — convenant bij gemeenschappelijk echtscheidingsverzoek',
'Een verzoekschrift tot echtscheiding ingediend door beide echtgenoten gaat vergezeld van een door hen ondertekend convenant. Dit convenant regelt ten minste: de verdeling van de huwelijksgemeenschap of de verrekening van het vermogen, de partneralimentatie, de pensioenverevening en de verdeling of het gebruik van de woning. Een incompleet convenant kan door de rechter worden teruggestuurd.',
ARRAY['convenant','volledigheid','pensioen','alimentatie','woning']),

('10000000-0000-0000-0000-000000000002', 2,
'art. 826 Rv — ouderschapsplan bij echtscheiding met kinderen',
'Bij een verzoekschrift tot echtscheiding waarbij minderjarige kinderen zijn betrokken, wordt een door de echtgenoten ondertekend ouderschapsplan gevoegd. Dit plan bevat ten minste: (a) de verdeling van de zorg- en opvoedingstaken (zorgregeling), (b) de wijze waarop de ouders elkaar informeren en raadplegen over de kinderen, (c) de kosten van verzorging en opvoeding (kinderalimentatie). Het ontbreken van één van deze drie onderdelen is een formeel gebrek dat de rechter kan leiden tot niet-ontvankelijkheid van het verzoek.',
ARRAY['ouderschapsplan','zorgregeling','informatieplicht','kinderalimentatie','kinderen_minderjarig']),

-- ════════════════════════════════════════════════════════════════════
-- WVPS — WET VEREVENING PENSIOENRECHTEN BIJ SCHEIDING
-- ════════════════════════════════════════════════════════════════════

('10000000-0000-0000-0000-000000000003', 1,
'WVPS art. 2 — standaard pensioenverevening 50/50',
'De gewezen echtgenoot heeft recht op verevening van het ouderdomspensioen dat de andere gewezen echtgenoot heeft opgebouwd tijdens het huwelijk. De standaard-vereveningsfractie is 50% van het tijdens het huwelijk opgebouwde pensioen. Dit recht geldt automatisch bij echtscheiding, tenzij partijen schriftelijk een andere regeling overeenkomen (WVPS art. 5). Zonder expliciete bepaling in het convenant geldt de wettelijke 50/50-verevening.',
ARRAY['pensioen','pensioenverevening','convenant']),

('10000000-0000-0000-0000-000000000003', 2,
'WVPS art. 5 — afwijking pensioenverevening',
'Partijen kunnen schriftelijk overeenkomen af te wijken van de standaard pensioenverevening (WVPS art. 2). Mogelijke afwijkingen: een andere verdeling dan 50/50, conversie (omzetting in een eigen zelfstandig pensioenrecht), of volledige afstand van vereveningsaanspraken. Een afwijkingsovereenkomst dient uitdrukkelijk schriftelijk te worden vastgelegd in het convenant. Zonder schriftelijke afwijking geldt automatisch de wettelijke verevening.',
ARRAY['pensioen','pensioenverevening','pensioenverevening_uitgesloten','convenant']),

('10000000-0000-0000-0000-000000000003', 3,
'WVPS art. 11 — meldingsplicht bij pensioenuitvoerder (2-jaarstermijn)',
'Art. 11 WVPS: De gerechtigde tot pensioenverevening dient de pensioenuitvoerder (het pensioenfonds of de verzekeraar) binnen 2 jaar na inschrijving van de echtscheiding in het register van burgerlijke stand te informeren over de vereveningsaanspraken. Gevolg van niet-tijdig melden: het recht op rechtstreekse betaling door de pensioenuitvoerder vervalt. De vereveningsaanspraak zelf blijft dan wel bestaan, maar de gerechtigde moet de verevening zelf innen bij de andere partij. Praktisch belang voor convenant: (1) Het convenant dient te vermelden dat partijen tijdig (binnen 2 jaar) de pensioenuitvoerder(s) informeren; (2) Geef aan wie verantwoordelijk is voor de melding (doorgaans de gerechtigde, maar partijen kunnen afspreken dit samen te doen); (3) Gebruik hiervoor het standaard WVPS-formulier beschikbaar via de pensioenuitvoerder. Let op: elke pensioenuitvoerder dient afzonderlijk geïnformeerd te worden als er meerdere pensioenrechten zijn.',
ARRAY['pensioen','pensioenverevening','convenant']),

-- ════════════════════════════════════════════════════════════════════
-- BW BOEK 3 — VERMOGENSRECHT
-- ════════════════════════════════════════════════════════════════════

('10000000-0000-0000-0000-000000000004', 1,
'art. 3:170 BW — beheer en beschikking gemeenschappelijk goed',
'Deelgenoten zijn slechts bevoegd tot beheers- en beschikkingshandelingen over gemeenschappelijk goed indien allen daartoe besluiten. Bij verdeling van een gezamenlijk koophuis moeten beide partijen instemmen met verkoop of toedeling. Het convenant dient te regelen: (1) wie de woning overneemt of dat de woning wordt verkocht, (2) de peildatum voor de waardebepaling, (3) wanneer de overdracht bij de notaris plaatsvindt, en (4) of de andere partij wordt ontslagen uit hoofdelijke aansprakelijkheid voor de hypotheek.',
ARRAY['woning','hypotheek','verdeling','eigen_woning','convenant']),

-- ════════════════════════════════════════════════════════════════════
-- WET INKOMSTENBELASTING 2001 — FISCALE ASPECTEN ECHTSCHEIDING
-- ════════════════════════════════════════════════════════════════════

('10000000-0000-0000-0000-000000000006', 1,
'IB 2001 art. 6.3 + 3.101 — fiscale behandeling partneralimentatie',
'BETALER partneralimentatie (art. 6.3 IB 2001 — persoonsgebonden aftrek):
Betaalde partneralimentatie is aftrekbaar als persoonsgebonden aftrek in box 1. Sinds de afbouw van de tariefscorrectie (ingevoerd 2020) geldt de aftrek tegen het basistarief box 1 (37,07% in 2025), ook als het inkomen in de hogere schijf valt. Let op: de aftrek bestaat nog steeds maar is gemaximeerd op het lage belastingtarief.

ONTVANGER partneralimentatie (art. 3.101 IB 2001 — periodieke uitkering):
Ontvangen partneralimentatie is volledig belast als inkomen in box 1 (progressief tarief). De ontvanger betaalt hier inkomstenbelasting over.

KINDERALIMENTATIE (art. 6.3 lid 2 IB 2001):
Kinderalimentatie is NIET aftrekbaar voor de betaler en NIET belast voor de ontvanger. Dit in tegenstelling tot partneralimentatie.

BELANG VOOR CONVENANT:
(1) Vermeld of de afgesproken alimentatie netto of bruto is bedoeld;
(2) Adviseer partijen de fiscale gevolgen te bespreken met een belastingadviseur;
(3) Bij een nihilbeding: vermeld dat er geen aftrekbare alimentatie is;
(4) De mediator/advocaat dient partijen te informeren over de fiscale asymmetrie (betaler trekt af, ontvanger betaalt belasting).',
ARRAY['partneralimentatie','alimentatie','fiscaal','convenant']),

('10000000-0000-0000-0000-000000000006', 2,
'IB 2001 art. 3.111 + 3.119a — eigen woning en renteaftrek na scheiding',
'SCHEIDINGSREGELING EIGEN WONING (art. 3.111 lid 4 IB 2001):
Na echtscheiding kan de vertrekkende partner gedurende maximaal 2 jaar de hypotheekrente blijven aftrekken als eigenwoningschuld, mits:
(a) de in de woning achterblijvende (voormalige) partner de woning als zijn/haar hoofdverblijf heeft, én
(b) de vertrekkende partner het eigenaarsaandeel nog niet heeft overgedragen.
Na 2 jaar of bij overdracht van het eigenaarsaandeel vervalt de aftrek voor de vertrekkende partner.

HYPOTHEEKRENTEAFTREK OVERNEMENDE PARTNER (art. 3.119a IB 2001):
Als de blijvende partner de woning overneemt en de hypotheek verhoogt om de andere partner uit te kopen, is de rente over dit extra hypotheekbedrag aftrekbaar als eigenwoningschuld (annuïtair aflossingsvereiste geldt).

BELANG VOOR CONVENANT:
(1) Vermeld wie in de woning blijft en wie vertrekt, en per welke datum;
(2) Vermeld wie de hypotheeklasten betaalt in de tussenperiode;
(3) Adviseer de vertrekkende partner de 2-jaarstermijn voor de scheidingsregeling te bewaken;
(4) Adviseer partijen fiscale gevolgen van uitkoop te bespreken met belastingadviseur of hypotheekadviseur.',
ARRAY['woning','hypotheek','fiscaal','eigen_woning','convenant']),

-- ════════════════════════════════════════════════════════════════════
-- PARTICIPATIEWET
-- ════════════════════════════════════════════════════════════════════

('10000000-0000-0000-0000-000000000007', 1,
'Participatiewet art. 62 — verhaalsrecht gemeente op alimentatieplichtige',
'Art. 62 Participatiewet: De gemeente kan de kosten van bijstandsverlening verhalen op degene die op grond van het burgerlijk recht verplicht is tot onderhoud van de bijstandsgerechtigde (de onderhoudsplichtige/alimentatieplichtige). De gemeente treedt hiermee op als "verhaalsgemeente" en kan de ex-partner aanspreken voor terugbetaling van de bijstand. BEPERKING DOOR ART. 1:159a BW: Als er een rechtsgeldig nihilbeding is op grond van art. 1:158 BW, is dit beding ook geldig jegens de gemeente (art. 1:159a BW). De gemeente kan dan GEEN verhaal nemen op de alimentatieplichtige. BELANG VOOR CONVENANT: (1) Als partijen afspreken dat er geen partneralimentatie verschuldigd is (nihilbeding), beschermt art. 1:159a BW de alimentatieplichtige ook tegen de gemeente; (2) Dit nihilbeding moet wél rechtsgeldig zijn — dus gebaseerd op art. 1:158 BW met bewuste instemming van beide partijen; (3) Een convenant dat partneralimentatie simpelweg op "nihil" stelt zonder nihilbeding-clausule biedt minder bescherming dan een uitdrukkelijk nihilbeding.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','participatiewet','convenant']);

-- ── Tremanormen (Rapport Alimentatienormen) ───────────────────────────
-- Bron: Expertgroep Alimentatienormen, gepubliceerd op rechtspraak.nl
-- ⚠ JAARLIJKS BIJWERKEN: cijfers gelden voor 2025. Controleer de meest
--   recente versie op: rechtspraak.nl/Onderwerpen/Paginas/Alimentatie.aspx
--   en update de bedragen (behoeftetabel en draagkrachttabel) elk januari.

INSERT INTO legal_sources (id, title, bwb_id, source_type, url, valid_from) VALUES
(
  '10000000-0000-0000-0000-000000000005',
  'Tremanormen — Rapport Alimentatienormen 2025 (Expertgroep Alimentatienormen)',
  NULL,
  'richtlijn',
  'https://www.rechtspraak.nl/Onderwerpen/Paginas/Alimentatie.aspx',
  '2025-01-01'
);

INSERT INTO legal_chunks (source_id, chunk_index, citation, content, topic_tags) VALUES

('10000000-0000-0000-0000-000000000005', 1,
'Tremanormen 2025 — Methode kinderalimentatie (§1–4)',
'De kinderalimentatie wordt berekend in drie stappen:

STAP 1 – BEHOEFTE VAN HET KIND:
De behoefte wordt vastgesteld aan de hand van het netto besteedbaar inkomen (NBI) van beide ouders ten tijde van het huwelijk (de welstandsmaatstaf). Maatgevend is de behoeftetabel van de Expertgroep (zie chunk 2). Voor elk volgend kind geldt een toeslag: 2e kind +20%, 3e kind +13%, etc.

STAP 2 – DRAAGKRACHT BEIDE OUDERS:
Per ouder wordt het huidige NBI vastgesteld (na aftrek loonheffing, ZVW-premie, pensioenpremie). Uit de draagkrachttabel (zie chunk 3) volgt de beschikbare draagkrachtruimte. Vervolgens wordt de bijdrage per ouder berekend naar rato van hun draagkracht: bijdrage ouder A = (draagkracht A / totale draagkracht) × behoefte kind.

STAP 3 – ZORGKORTING:
De ouder die betaalt ontvangt een zorgkorting op zijn bijdrage ter compensatie van de kosten die hij maakt tijdens zijn zorgaandeel. Percentages: minder dan 25% zorg = 15%, 25–50% zorg = 25%, meer dan 50% zorg (co-ouderschap) = 35%.

CONTROLE IN CONVENANT/OUDERSCHAPSPLAN:
- Is de behoefteberekening opgenomen (NBI-bronnen, behoeftetabel, kindaantal)?
- Is de draagkrachtberekening van beide ouders uitgewerkt?
- Is de zorgkorting correct toegepast?
- Is de ingangsdatum vermeld (doorgaans datum inschrijving echtscheiding of eerder)?
- Is indexering per 1 januari afgesproken conform CBS-indexcijfer?',
ARRAY['kinderalimentatie','alimentatie','tremanormen','ouderschapsplan','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000005', 2,
'Tremanormen 2025 — Behoeftetabel kinderalimentatie (tabel 1)',
'BEHOEFTETABEL 2025 — netto behoefte per kind per maand, gebaseerd op gecombineerd NBI van beide ouders ten tijde van huwelijk. Bedragen in euro per maand (1 kind; meerkindfactor apart toe te passen).

Gecombineerd NBI → behoefte 1 kind:
≤ €1.000   → €201
€1.100     → €228
€1.200     → €254
€1.300     → €279
€1.400     → €304
€1.500     → €328
€1.700     → €372
€1.900     → €413
€2.100     → €452
€2.400     → €504
€2.700     → €553
€3.000     → €598
€3.500     → €662
€4.000     → €720
€4.500     → €772
€5.000     → €819
€6.000     → €903
€7.000     → €977
€8.000     → €1.044
€10.000    → €1.162
≥ €12.000  → behoefte vast te stellen op basis van werkelijke kosten

MEERKINDFACTOR (toeslag op behoefte 1 kind):
2 kinderen: factor 1,40 (dus behoefte 2 kinderen = 1,40 × tabel-bedrag, dan /2 per kind)
3 kinderen: factor 1,70
4 kinderen: factor 1,90

⚠ Bovenstaande bedragen gelden per 1 januari 2025. Controleer jaarlijks de geïndexeerde tabel op rechtspraak.nl.',
ARRAY['kinderalimentatie','alimentatie','tremanormen','ouderschapsplan','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000005', 3,
'Tremanormen 2025 — Draagkrachttabel en berekening draagkracht',
'DRAAGKRACHTTABEL 2025 — beschikbare draagkracht per ouder per maand op basis van individueel NBI.

NBI ouder (netto/maand) → beschikbare draagkrachtruimte (per maand):
≤ €1.075   → nihil (onder bijstandsnorm, geen draagkracht)
€1.100     → €25
€1.200     → €90
€1.300     → €155
€1.400     → €220
€1.500     → €285
€1.600     → €345
€1.700     → €400
€1.900     → €500
€2.100     → €600
€2.300     → €695
€2.500     → €785
€2.750     → €890
€3.000     → €990
€3.500     → €1.165
€4.000     → €1.330
€5.000     → €1.620
≥ €6.000   → vrije berekening: 70% × (NBI − forfaitaire lasten)

REKENMETHODE (berekening vrije ruimte boven €6.000 NBI):
Forfaitaire woonlast: 30% × NBI (max €875/maand)
Overige lasten: vaste bedrag per normstelsel (1-persoonshuishouden: ca. €875/maand)
Draagkrachtruimte = NBI − woonlast − overige lasten
Beschikbaar voor alimentatie = 70% × draagkrachtruimte

⚠ Bijstandsnorm 2025 (alleenstaande): ±€1.075 netto/maand. NBI hieronder → geen draagkracht.
⚠ Bedragen gelden per 1 januari 2025. Controleer jaarlijks op rechtspraak.nl.',
ARRAY['kinderalimentatie','alimentatie','tremanormen','ouderschapsplan','kinderen_minderjarig']),

('10000000-0000-0000-0000-000000000005', 4,
'Tremanormen 2025 — Partneralimentatie: jusvergelijking',
'METHODE PARTNERALIMENTATIE (Tremanormen 2025 §5):

De hoogte van partneralimentatie wordt bepaald via de jusvergelijking (netto-netto vergelijking):

STAP 1 – BEHOEFTE ONDERHOUDSGERECHTIGDE:
Uitgangspunt: 60% van het gezamenlijk NBI tijdens huwelijk (welstandsmaatstaf). Dit bedrag wordt verminderd met het eigen inkomen van de onderhoudsgerechtigde. Minimum: leefnorm bijstand (±€1.075/maand netto).

STAP 2 – DRAAGKRACHT ONDERHOUDSPLICHTIGE:
NBI onderhoudsplichtige minus eigen noodzakelijke lasten (inclusief heffingskortingen). Beschikbaar = resterende "jus" (financiële ruimte boven minimumbudget).

STAP 3 – JUSVERGELIJKING:
De alimentatie is het laagste van:
(a) de vastgestelde behoefte van de onderhoudsgerechtigde, of
(b) de beschikbare draagkracht van de onderhoudsplichtige.
Na betaling dienen beide partijen een vergelijkbaar netto bestedingsniveau te hebben.

AANDACHTSPUNTEN VOOR CONVENANT:
- Is de behoefteberekening onderbouwd (60%-norm of werkelijke kosten)?
- Is de ingangsdatum vermeld?
- Is de duur bepaald (wettelijk: helft huwelijksduur, max. 5 jaar tenzij uitzonderingen)?
- Is een nihilbeding of afstandsverklaring uitdrukkelijk opgenomen als geen alimentatie verschuldigd is (art. 1:158 BW)?
- Is indexering per 1 januari afgesproken?
- Is fiscale verwerking correct (onderhoudsplichtige: aftrekbaar box 1; gerechtigde: belast)?

⚠ Tremanormen zijn richtlijnen, geen wet. Gemotiveerde afwijking is toegestaan maar dient expliciet in het convenant te worden opgenomen.',
ARRAY['partneralimentatie','alimentatie','tremanormen','convenant','nihilbeding']);

-- ── Controleer resultaat ─────────────────────────────────────────────
SELECT ls.title, lc.citation, array_length(lc.topic_tags, 1) AS tags, lc.topic_tags
FROM legal_chunks lc
JOIN legal_sources ls ON ls.id = lc.source_id
ORDER BY lc.source_id, lc.chunk_index;
