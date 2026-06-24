import { Document, Packer, Paragraph, HeadingLevel, TextRun } from 'docx';

function regelsVoorItem({ vinkjeAan, koptekst, body, citaat, opmerking }) {
  const regels = [
    new Paragraph({
      children: [
        new TextRun({ text: vinkjeAan ? '\u2611 ' : '\u2610 ', bold: true }),
        new TextRun({ text: koptekst, bold: true }),
      ],
      spacing: { before: 160 },
    }),
  ];
  if (body) regels.push(new Paragraph({ text: body }));
  if (citaat) regels.push(new Paragraph({ children: [new TextRun({ text: citaat, italics: true })] }));
  if (opmerking) regels.push(new Paragraph({ children: [new TextRun({ text: `Opmerking: ${opmerking}`, italics: true, color: 'C75A38' })] }));
  return regels;
}

function sectie(children, titel, items, naarRegels) {
  children.push(new Paragraph({ text: titel, heading: HeadingLevel.HEADING_1, spacing: { before: 320 } }));
  if (!items || items.length === 0) {
    children.push(new Paragraph({ text: 'Geen opmerkingen.' }));
    return;
  }
  for (const item of items) children.push(...naarRegels(item));
}

export default async function handler(req, res) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Alleen POST' });
  try {
    const { bestandsnaam, classificatie, rapport } = req.body;
    if (!classificatie || !rapport) return res.status(400).json({ error: 'classificatie en rapport zijn verplicht' });

    const children = [];
    children.push(new Paragraph({ text: 'Documentscreening', heading: HeadingLevel.TITLE }));
    children.push(new Paragraph({ children: [new TextRun({ text: bestandsnaam || '(onbekend bestand)', italics: true })] }));
    children.push(new Paragraph({ text: `Type: ${classificatie.doc_type}`, spacing: { before: 120 } }));
    children.push(new Paragraph({ text: classificatie.samenvatting }));

    children.push(new Paragraph({ text: 'Samenvatting', heading: HeadingLevel.HEADING_1, spacing: { before: 320 } }));
    children.push(new Paragraph({ text: rapport.samenvatting || '' }));

    sectie(children, 'Volledigheid', rapport.volledigheid, (v) =>
      regelsVoorItem({ vinkjeAan: v.afgehandeld, koptekst: `${v.sectie} — ${v.status}`, body: v.toelichting, opmerking: v.opmerking })
    );
    sectie(children, 'Juridische juistheid', rapport.juridisch, (j) =>
      regelsVoorItem({ vinkjeAan: j.afgehandeld, koptekst: `${j.onderwerp} (${j.ernst})`, body: j.bevinding, citaat: j.citaat, opmerking: j.opmerking })
    );
    sectie(children, 'Balans tussen partijen', rapport.balans, (b) =>
      regelsVoorItem({ vinkjeAan: b.afgehandeld, koptekst: `${b.signalering} (${b.ernst})`, opmerking: b.opmerking })
    );
    sectie(children, 'Grammatica & taal', rapport.grammatica, (g) =>
      regelsVoorItem({ vinkjeAan: g.afgehandeld, koptekst: g.locatie, body: `${g.probleem} \u2192 ${g.suggestie}`, opmerking: g.opmerking })
    );

    const doc = new Document({ sections: [{ children }] });
    const buffer = await Packer.toBuffer(doc);

    const veiligeNaam = (bestandsnaam || 'rapport').replace(/\.[^.]+$/, '').replace(/[^a-z0-9_-]+/gi, '_');
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
    res.setHeader('Content-Disposition', `attachment; filename="screening-${veiligeNaam}.docx"`);
    return res.status(200).send(buffer);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: err.message });
  }
}
