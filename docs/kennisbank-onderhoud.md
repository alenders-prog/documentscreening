# Onderhoud Juridische Kennisbank

Dit document beschrijft wat wanneer bijgewerkt moet worden in de `legal_chunks`-tabel in Supabase, en hoe je dat doet.

---

## Overzicht: wat staat er in de kennisbank?

De kennisbank bevat wetteksten en richtlijnen die Claude gebruikt bij de analyse van echtscheidingsdocumenten. Alles staat in `legal_chunks_seed.sql`.

| Categorie | Artikelen |
|---|---|
| **BW Boek 1 — Vermogen** | art. 1:94 (2× pre/na 2018), 1:99-100, 1:114, 1:121, 1:132-133, 1:141, 1:94 lid 3/1:95 |
| **BW Boek 1 — Alimentatie** | art. 1:157, 1:158, 1:159, **1:159a**, 1:160, 1:397, 1:401, 1:402, 1:408 |
| **BW Boek 1 — Kinderen** | art. 1:404, 1:247, 1:253a, 1:253n, 1:377a-377b |
| **Rv** | art. 815, 826 |
| **WVPS** | art. 2, 5, **11** |
| **BW Boek 3** | art. 3:170 |
| **IB 2001** | art. 6.3+3.101 (alimentatie fiscaal), art. 3.111+3.119a (eigen woning) |
| **Participatiewet** | art. 62 |
| **Tremanormen** | Methode, behoeftetabel, draagkrachttabel, partneralimentatie |

---

## Jaarlijkse update: Tremanormen (elk januari)

De Tremanormen worden jaarlijks per 1 januari bijgewerkt door de Expertgroep Alimentatienormen. De tabel-bedragen (behoeftetabel, draagkrachttabel) wijzigen elk jaar met het CBS-indexcijfer.

### Wanneer?
- **Controleer elke januari** of nieuwe Tremanormen zijn gepubliceerd.
- Bron: [rechtspraak.nl/Onderwerpen/Paginas/Alimentatie.aspx](https://www.rechtspraak.nl/Onderwerpen/Paginas/Alimentatie.aspx)

### Wat bijwerken?
In `legal_chunks_seed.sql`, zoek op `Tremanormen 2025` en vervang:
1. De **behoeftetabel** (chunk index 2) — alle euro-bedragen bijwerken
2. De **draagkrachttabel** (chunk index 3) — alle euro-bedragen bijwerken + bijstandsnorm
3. Het **jaar** in alle Tremanormen-citations: `Tremanormen 2025` → `Tremanormen 2026`
4. De `valid_from` datum van de Tremanormen-bron onderaan het bestand

### Hoe uitvoeren?
1. Open `legal_chunks_seed.sql` in VSCode
2. Pas de bedragen aan
3. Ga naar Supabase SQL-editor → plak de volledige inhoud van het bestand → Klik "Run"

---

## Bij wetswijzigingen (onregelmatig)

### Hoe kom je erachter?
- Abonneer op [wetten.overheid.nl](https://wetten.overheid.nl) voor alerts op specifieke BWB-nummers
- Of volg [rechtspraak.nl](https://www.rechtspraak.nl) voor uitspraken over echtscheiding

### Wat te doen bij een wetswijziging?
1. Zoek het gewijzigde artikel op in `legal_chunks_seed.sql`
2. Pas de inhoud aan
3. Herrun het SQL-bestand in Supabase

### Nieuwe artikelen toevoegen?
Voeg onderaan de juiste sectie in `legal_chunks_seed.sql` een nieuw blok toe:

```sql
('10000000-0000-0000-0000-000000000001', 23,  -- source_id + volgend chunk_index
'art. X:XX BW — korte omschrijving',
'Volledige wettekst of samenvatting met praktische aandachtspunten voor het convenant...',
ARRAY['tag1','tag2','tag3']),
```

### Topic tags — overzicht
Gebruik bestaande tags zodat de retrieval werkt:

| Tag | Wanneer gebruiken |
|---|---|
| `convenant` | Alle artikelen die relevant zijn voor het convenant |
| `ouderschapsplan` | Alle artikelen over kinderaangelegenheden |
| `alimentatie` | Algemeen alimentatie (beide soorten) |
| `partneralimentatie` | Specifiek partneralimentatie |
| `kinderalimentatie` | Specifiek kinderalimentatie |
| `nihilbeding` | Nihilbeding partneralimentatie |
| `tremanormen` | Tremanormen-richtlijnen |
| `pensioen` | Pensioenverevening |
| `pensioenverevening` | Pensioenverevening standaard |
| `pensioenverevening_uitgesloten` | Pensioenverevening afgeweken of uitgesloten |
| `vermogen` | Vermogensverdeling |
| `verdeling` | Verdeling goederen |
| `gemeenschap_van_goederen` | Algehele gemeenschap (pre-2018) |
| `beperkte_gemeenschap` | Beperkte gemeenschap (post-2018) |
| `huwelijk_voor_2018` | Huwelijken gesloten vóór 1-1-2018 |
| `huwelijk_na_2018` | Huwelijken gesloten na 1-1-2018 |
| `huwelijkse_voorwaarden` | Huwelijkse voorwaarden (alle stelsels) |
| `koude_uitsluiting` | Koude uitsluiting |
| `verrekenbeding` | Verrekenbeding |
| `uitsluitingsclausule` | Uitsluitingsclausule / erfenissen |
| `woning` | Eigen woning behandeling |
| `eigen_woning` | Eigen woning (fiscaal of goederenrecht) |
| `hypotheek` | Hypotheek en hoofdelijke aansprakelijkheid |
| `fiscaal` | Fiscale aspecten (IB 2001) |
| `gezag` | Ouderlijk gezag |
| `gezamenlijk_gezag` | Gezamenlijk gezag |
| `omgang` | Omgang / contactregeling |
| `informatieplicht` | Informatie- en consultatieverplichting |
| `zorgregeling` | Zorgregeling / verblijfsregeling |
| `kinderen_minderjarig` | Aanwezig als er minderjarige kinderen zijn |
| `geschillenregeling` | Geschillenregeling / escalatiebepaling |
| `volledigheid` | Formele volledigheid convenant/ouderschapsplan |
| `participatiewet` | Interactie met bijstand/gemeente |

---

## Volledigheidscheck uitvoeren

Je kunt automatisch controleren of alle verwachte chunks aanwezig zijn in de database:

```bash
node scripts/check-legal-chunks.js
```

Het script vergelijkt de huidige database-inhoud met de referentielijst en rapporteert wat ontbreekt.

---

## Wat te doen als Claude een artikel als "niet bestaand" aanmerkt?

Als Claude in de analyse aangeeft dat een bepaald wetsartikel "niet bestaat" terwijl het wél bestaat:

1. **Controleer** of het artikel in `legal_chunks_seed.sql` staat
2. **Als het ontbreekt**: voeg het toe aan het SQL-bestand
3. **Herrun** het SQL-bestand in Supabase SQL-editor
4. Voer daarna een nieuwe analyse uit — Claude krijgt nu de juiste context

### Verificatie van wetteksten
- Actuele Nederlandse wetgeving: [wetten.overheid.nl](https://wetten.overheid.nl)
- Alimentatienormen: [rechtspraak.nl/alimentatie](https://www.rechtspraak.nl/Onderwerpen/Paginas/Alimentatie.aspx)

---

*Bijgewerkt: juni 2026*
