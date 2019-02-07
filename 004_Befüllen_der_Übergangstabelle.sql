/* Zusammenfassung der Daten in der Übergangstabelle */

-- Einfügen vom Inhalt von Hilfstabelle_Karasek
INSERT INTO übergangstabelle (titel, autor, sprache, nummer_karasek, beschreibung)
SELECT titel, autor, sprache, nummer, beschreibung FROM hilfstabelle_karasek;

-- Hinzufügen vom Inhalt von Le Monde unter Vermeidung von Doppelungen
MERGE INTO übergangstabelle ü
USING (SELECT * FROM hilfstabelle_lemonde) lm
ON (ü.titel = lm.titel AND ü.autor = lm.autor AND ü.sprache = lm.sprache)
WHEN MATCHED THEN
UPDATE SET
ü.jahr1 = lm.jahr1,
ü.jahr2 = lm.jahr2,
ü.nummer_lemonde = lm.nummer
WHEN NOT MATCHED THEN
INSERT VALUES(
    lm.titel,
    NULL,
    NULL,
    lm.autor,
    NULL,
    NULL,
    NULL,
    lm.sprache,
    lm.jahr1,
    lm.jahr2,
    NULL,
    NULL,
    lm.nummer,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL);
-- Hinzufügen des Originaltitels für Werke, die von französisch-sprachigen Autoren geschrieben wurden:
UPDATE übergangstabelle outer_table
SET originaltitel =
    (   SELECT titre 
        FROM hilfstabelle_lemonde_fr inner_table
        WHERE   inner_table.no      = outer_table.nummer_lemonde
        AND     inner_table.auteur  = outer_table.autor);
-- Alle Originaltitel von nicht französisch-sprachigen Autoren werden wieder NULL gesetzt:
UPDATE übergangstabelle
SET originaltitel = NULL
WHERE sprache != 'Französisch';
-- Test: Werke, die von Karasek und LeMonde empfohlen wurden:
SELECT * FROM übergangstabelle WHERE nummer_karasek IS NOT NULL AND nummer_lemonde IS NOT NULL;


-- Hinzufügen vom Inhalt von Zeit unter Vermeidung von Doppelungen
MERGE INTO übergangstabelle ü
USING (SELECT * FROM hilfstabelle_zeit) z
ON (ü.titel = z.titel AND ü.autor = z.autor AND ü.sprache = z.sprache)
WHEN MATCHED THEN
UPDATE SET
ü.jahr1 = z.jahr1,
ü.jahr2 = z.jahr2,
ü.nummer_zeit = z.nummer,
ü.rezensent = z.rezensent
WHEN NOT MATCHED THEN
INSERT VALUES(
    z.titel,
    NULL,
    NULL,
    z.autor,
    NULL,
    NULL,
    NULL,
    z.sprache,
    z.jahr1,
    z.jahr2,
    NULL,
    z.nummer,
    NULL,
    NULL,
    NULL,
    z.rezensent,
    NULL,
    NULL,
    NULL);
-- Test, welche Bücher auf sowohl von Karasek wie auch von der Zeit empfohlen wurden:
SELECT * FROM übergangstabelle
WHERE nummer_karasek IS NOT NULL AND nummer_zeit IS NOT NULL;
-- Test, welche Bücher auf sowohl von Le Monde wie auch von der Zeit empfohlen wurden:
SELECT * FROM übergangstabelle
WHERE nummer_lemonde IS NOT NULL AND nummer_zeit IS NOT NULL;

-- Hinzufügen vom Inhalt der BBC-Liste unter Vermeidung von Doppelungen
MERGE INTO übergangstabelle ü
USING (SELECT * FROM hilfstabelle_bbc) bbc
ON (ü.titel = bbc.deutscher_titel AND ü.autor = bbc.autor AND ü.sprache = bbc.sprache)
WHEN MATCHED THEN
UPDATE SET
ü.originaltitel = bbc.originaltitel,
ü.jahr1 = bbc.jahr1,
ü.jahr2 = bbc.jahr2,
ü.nummer_bbc = bbc.nummer
WHEN NOT MATCHED THEN
INSERT VALUES(
    bbc.deutscher_titel,
    NULL,
    bbc.originaltitel,
    bbc.autor,
    NULL,
    NULL,
    NULL,
    bbc.sprache,
    bbc.jahr1,
    bbc.jahr2,
    NULL,
    NULL,
    NULL,
    bbc.nummer,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL);
-- Test, welche Bücher auf sowohl von der BBC wie auch von der Zeit empfohlen wurden:
SELECT * FROM übergangstabelle
WHERE nummer_bbc IS NOT NULL AND nummer_zeit IS NOT NULL;


-- Definieren der author_ID
UPDATE übergangstabelle SET autor_vorname  = SUBSTR(autor, 1, INSTR(autor, ' ', -1));
UPDATE übergangstabelle SET autor_nachname = SUBSTR(autor, INSTR(autor, ' ', -1)+1);
UPDATE übergangstabelle SET author_id = SUBSTR(autor_nachname, 1, 5) || SUBSTR(autor_vorname, 1, 3);

-- manuelle Überprüfung
SELECT COUNT(DISTINCT(autor)) FROM übergangstabelle;
SELECT COUNT(DISTINCT(author_id)) FROM übergangstabelle;
SELECT autor, autor_vorname, autor_nachname, author_id FROM übergangstabelle ORDER BY author_id;


-- Definieren der book_ID
-- Create sequence for book_IDs
-- DROP SEQUENCE book_ID_seq;
CREATE SEQUENCE book_ID_seq
START WITH 9780000000001
INCREMENT BY 1;
-- Einfügen der book_ID_numbers in die Übergangstabelle
-- da 'Asterix der Gallier' zwei Autoren hat, wird die Zeile für den Zweitautor Albert Uderzo ausgelassen
UPDATE übergangstabelle
SET book_ID = book_ID_seq.nextval
WHERE author_ID <> 'UderzAlb';
-- Einfügen der Book_ID für 'Asterix der Gallier' in die ausgelassene Zeile:
UPDATE übergangstabelle
SET book_ID = (SELECT book_id FROM übergangstabelle WHERE author_id = 'GosciRen')
WHERE author_id = 'UderzAlb';

-- Extraction der Rezensenten-Vornamen / Erstellen der Rezensenten-ID:
UPDATE übergangstabelle SET rezensent_vorname  = SUBSTR(rezensent, 1, INSTR(rezensent, ' ', -1));
UPDATE übergangstabelle SET rezensent_nachname = SUBSTR(rezensent, INSTR(rezensent, ' ', -1)+1);
UPDATE übergangstabelle SET rezensent_id = SUBSTR(rezensent_nachname, 1, 5) || SUBSTR(rezensent_vorname, 1, 3);

-- visuelle Überprüfung der fertigen Tabelle:
SELECT * FROM übergangstabelle;