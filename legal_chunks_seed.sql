-- ══════════════════════════════════════════════════════════════════════
-- legal_chunks — Wetsartikelen voor echtscheidingsdocumenten
-- Uitvoeren in Supabase SQL-editor
-- ══════════════════════════════════════════════════════════════════════

TRUNCATE legal_chunks;  -- schone lei; verwijder deze regel als je wil aanvullen

INSERT INTO legal_chunks (citation, content, topic_tags) VALUES

-- ── BOEK 1 BW — FAMILIERECHT ────────────────────────────────────────

('art. 1:157 BW',
'De rechter kan op verzoek van één der echtgenoten bij de echtscheidingsbeschikking of bij latere uitspraak bepalen dat de ene echtgenoot verplicht is de andere uitkering tot levensonderhoud (partneralimentatie) te verstrekken. De alimentatieverplichting eindigt na verloop van een periode gelijk aan de helft van de duur van het huwelijk, met een maximum van twaalf jaar. Dat maximum geldt niet als het huwelijk langer dan vijftien jaar heeft geduurd en de onderhoudsgerechtigde binnen tien jaar de pensioengerechtigde leeftijd bereikt.',
ARRAY['partneralimentatie','alimentatie','convenant']),

('art. 1:158 BW',
'Echtgenoten kunnen bij overeenkomst, ook staande huwelijk, het recht op levensonderhoud na echtscheiding uitsluiten of beperken. Een zodanige overeenkomst verliest haar kracht niet doordat de omstandigheden wijzigen.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('art. 1:159 BW',
'Indien de echtgenoten bij huwelijkse voorwaarden of bij andere overeenkomst levensonderhoud na echtscheiding hebben vastgesteld of uitgesloten, kan de rechter op verzoek van de onderhoudsgerechtigde, indien zij ongewijzigd in stand laten van die overeenkomst naar maatstaven van redelijkheid en billijkheid niet kan worden gevergd, de overeenkomst op dit punt wijzigen. Een nihilbeding is alleen rechtsgeldig als beide partijen er bewust en geïnformeerd mee hebben ingestemd.',
ARRAY['partneralimentatie','alimentatie','nihilbeding','convenant']),

('art. 1:404 BW',
'Ouders zijn verplicht naar draagkracht te voorzien in de kosten van verzorging en opvoeding van hun minderjarige kinderen. De maatstaf voor kinderalimentatie is de behoefte van het kind (Tremanormen) afgezet tegen de draagkracht van de onderhoudsplichtige. Een afwijking van de Tremanormen dient gemotiveerd te worden.',
ARRAY['kinderalimentatie','alimentatie','ouderschapsplan','convenant']),

('art. 1:94 BW',
'De gemeenschap omvat, wat haar baten betreft, alle tegenwoordige en toekomstige goederen der echtgenoten, met uitzondering van goederen ten aanzien waarvan bij huwelijkse voorwaarden of bij een gift, making of erfstelling is bepaald dat zij buiten de gemeenschap vallen (privévermogen). Bij huwelijksvermogensrecht is het essentieel dat het convenant specificeert welke goederen tot de gemeenschap behoren en hoe de verdeling plaatsvindt.',
ARRAY['vermogen','verdeling','gemeenschap','convenant']),

('art. 1:121 BW',
'Indien een verrekenbeding in huwelijkse voorwaarden niet of niet volledig is nageleefd, worden aan het einde van het huwelijk de op dat moment aanwezige vermogens als te verrekenen vermogen aangemerkt, tenzij uit de huwelijkse voorwaarden anders voortvloeit. Het convenant dient te bevestigen of verrekenbedingen uit huwelijkse voorwaarden zijn nagekomen of anderszins zijn afgewikkeld.',
ARRAY['huwelijksevoorwaarden','verrekenbeding','vermogen','convenant']),

('art. 1:81 BW',
'Echtgenoten zijn elkander getrouwheid, hulp en bijstand verschuldigd. Zij zijn verplicht elkander het nodige te verschaffen. Deze zorgplicht eindigt pas formeel na inschrijving van de echtscheidingsbeschikking in de registers van de burgerlijke stand. Het convenant moet duidelijk maken wie de kosten van de gezamenlijke huishouding draagt tot aan de datum van de feitelijke scheiding.',
ARRAY['convenant','alimentatie','datum']),

-- ── WETBOEK VAN BURGERLIJKE RECHTSVORDERING ─────────────────────────

('art. 815 Rv',
'Een verzoekschrift tot echtscheiding, ingediend door beide echtgenoten gezamenlijk, gaat vergezeld van een door de echtgenoten ondertekend convenant. Dit convenant regelt in ieder geval: (a) de verdeling van de huwelijksgemeenschap of de verrekening van het vermogen, (b) de alimentatie, (c) de pensioenverevening, (d) de verdeling van de woning. Het convenant moet volledig zijn; een incompleet convenant kan door de rechter worden teruggestuurd.',
ARRAY['convenant','volledigheid','woning','pensioen','alimentatie']),

('art. 826 Rv',
'Bij een verzoekschrift tot echtscheiding waarbij minderjarige kinderen zijn betrokken, wordt een door de echtgenoten ondertekend ouderschapsplan gevoegd. Dit plan bevat in ieder geval: (a) de verdeling van de zorg- en opvoedingstaken (zorgregeling), (b) de wijze waarop informatie en consultatieverplichting wordt ingevuld, (c) de kosten van verzorging en opvoeding (kinderalimentatie). Het ontbreken van één van deze drie onderdelen is een formeel gebrek.',
ARRAY['ouderschapsplan','zorgregeling','informatieplicht','kinderalimentatie']),

-- ── PENSIOENWET / WVPS ───────────────────────────────────────────────

('WVPS art. 2',
'De gewezen echtgenoot heeft recht op verevening van het ouderdomspensioen van de andere gewezen echtgenoot. Het recht op verevening geldt voor het pensioen dat is opgebouwd tijdens het huwelijk. De standaard-vereveningsfractie is 50/50 van het tijdens het huwelijk opgebouwde pensioen (tenzij partijen anders overeenkomen).',
ARRAY['pensioen','pensioenverevening','convenant']),

('WVPS art. 5',
'Partijen kunnen schriftelijk overeenkomen af te wijken van de standaard pensioenverevening. Dit kan inhouden: een andere verdeling, conversie (omzetting in een eigen pensioenrecht), of volledige afstand. Een afwijking dient uitdrukkelijk schriftelijk te worden vastgelegd. Zonder expliciete afwijkingsovereenkomst geldt de wettelijke 50/50-verevening automatisch.',
ARRAY['pensioen','pensioenverevening','afstand','conversie','convenant']),

-- ── SPECIFIEK VOOR OUDERSCHAPSPLAN ──────────────────────────────────

('art. 1:247 BW',
'Het ouderlijk gezag omvat de plicht en het recht van de ouder zijn minderjarig kind te verzorgen en op te voeden. Ouders behouden na echtscheiding gezamenlijk het ouderlijk gezag tenzij de rechter anders bepaalt. Het ouderschapsplan dient te bevestigen dat het gezamenlijk gezag gecontinueerd wordt, of moet vermelden waarom eenhoofdig gezag is gevraagd.',
ARRAY['gezag','ouderschapsplan','kinderen']),

('art. 1:377b BW',
'De ouder bij wie het kind niet zijn hoofdverblijfplaats heeft, heeft het recht op en de verplichting tot omgang met het kind. De andere ouder is gehouden de omgang mogelijk te maken. In het ouderschapsplan dient de informatieverplichting en consultatieverplichting (recht op informatie over de ontwikkeling van het kind) expliciet te worden opgenomen.',
ARRAY['omgang','informatieplicht','ouderschapsplan','zorgregeling']),

('art. 1:253a BW',
'In geval van gezamenlijk gezag na scheiding kunnen ouders bij de rechter een geschillenregeling verzoeken als zij er niet uitkomen. Het ouderschapsplan doet er verstandig aan een escalatiebepaling of mediationclausule op te nemen voor het geval partijen in de toekomst een meningsverschil krijgen over de uitvoering van het plan.',
ARRAY['geschillenregeling','ouderschapsplan','gezag']),

-- ── WONING ───────────────────────────────────────────────────────────

('art. 3:170 BW',
'Deelgenoten zijn slechts bevoegd tot beheers- en beschikkingshandelingen over gemeenschappelijk goed indien allen daartoe besluiten. Bij verdeling van een gezamenlijk koophuis moeten beide partijen instemmen met de verkoop of toedeling. Het convenant dient specifiek te regelen: (1) wie de woning overneemt of dat de woning wordt verkocht, (2) de peildatum voor de waardebepaling, (3) of en wanneer de andere partij wordt ontslagen uit de hoofdelijke aansprakelijkheid voor de hypotheek.',
ARRAY['woning','hypotheek','verdeling','convenant']),

('art. 7:226 BW',
'Bij vervreemding van een verhuurde zaak treedt de verkrijger in de rechten en verplichtingen van de verhuurder. Als de echtelijke woning een huurwoning is, dient het convenant te regelen wie de huurovereenkomst voortzet en of de verhuurder toestemming heeft gegeven.',
ARRAY['woning','huur','convenant']);

-- Controleer het resultaat:
SELECT citation, topic_tags FROM legal_chunks ORDER BY citation;
