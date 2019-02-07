/* Zusammenfassung der Daten in der �bergangstabelle */

-- Einf�gen vom Inhalt von Hilfstabelle_Karasek
INSERT INTO �bergangstabelle (titel, autor, sprache, nummer_karasek, beschreibung)
SELECT titel, autor, sprache, nummer, beschreibung FROM hilfstabelle_karasek;

-- Hinzuf�gen vom Inhalt von Le Monde unter Vermeidung von Doppelungen
MERGE INTO �bergangstabelle �
USING (SELECT * FROM hilfstabelle_lemonde) lm
ON (�.titel = lm.titel AND �.autor = lm.autor AND �.sprache = lm.sprache)
WHEN MATCHED THEN
UPDATE SET
�.jahr1 = lm.jahr1,
�.jahr2 = lm.jahr2,
�.nummer_lemonde = lm.nummer
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
-- Hinzuf�gen des Originaltitels f�r Werke, die von franz�sisch-sprachigen Autoren geschrieben wurden:
UPDATE �bergangstabelle outer_table
SET originaltitel =
    (   SELECT titre 
        FROM hilfstabelle_lemonde_fr inner_table
        WHERE   inner_table.no      = outer_table.nummer_lemonde
        AND     inner_table.auteur  = outer_table.autor);
-- Alle Originaltitel von nicht franz�sisch-sprachigen Autoren werden wieder NULL gesetzt:
UPDATE �bergangstabelle
SET originaltitel = NULL
WHERE sprache != 'Franz�sisch';
-- Test: Werke, die von Karasek und LeMonde empfohlen wurden:
SELECT * FROM �bergangstabelle WHERE nummer_karasek IS NOT NULL AND nummer_lemonde IS NOT NULL;


-- Hinzuf�gen vom Inhalt von Zeit unter Vermeidung von Doppelungen
MERGE INTO �bergangstabelle �
USING (SELECT * FROM hilfstabelle_zeit) z
ON (�.titel = z.titel AND �.autor = z.autor AND �.sprache = z.sprache)
WHEN MATCHED THEN
UPDATE SET
�.jahr1 = z.jahr1,
�.jahr2 = z.jahr2,
�.nummer_zeit = z.nummer,
�.rezensent = z.rezensent
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
-- Test, welche B�cher auf sowohl von Karasek wie auch von der Zeit empfohlen wurden:
SELECT * FROM �bergangstabelle
WHERE nummer_karasek IS NOT NULL AND nummer_zeit IS NOT NULL;
-- Test, welche B�cher auf sowohl von Le Monde wie auch von der Zeit empfohlen wurden:
SELECT * FROM �bergangstabelle
WHERE nummer_lemonde IS NOT NULL AND nummer_zeit IS NOT NULL;

-- Hinzuf�gen vom Inhalt der BBC-Liste unter Vermeidung von Doppelungen
MERGE INTO �bergangstabelle �
USING (SELECT * FROM hilfstabelle_bbc) bbc
ON (�.titel = bbc.deutscher_titel AND �.autor = bbc.autor AND �.sprache = bbc.sprache)
WHEN MATCHED THEN
UPDATE SET
�.originaltitel = bbc.originaltitel,
�.jahr1 = bbc.jahr1,
�.jahr2 = bbc.jahr2,
�.nummer_bbc = bbc.nummer
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
-- Test, welche B�cher auf sowohl von der BBC wie auch von der Zeit empfohlen wurden:
SELECT * FROM �bergangstabelle
WHERE nummer_bbc IS NOT NULL AND nummer_zeit IS NOT NULL;


-- Definieren der author_ID
UPDATE �bergangstabelle SET autor_vorname  = SUBSTR(autor, 1, INSTR(autor, ' ', -1));
UPDATE �bergangstabelle SET autor_nachname = SUBSTR(autor, INSTR(autor, ' ', -1)+1);
UPDATE �bergangstabelle SET author_id = SUBSTR(autor_nachname, 1, 5) || SUBSTR(autor_vorname, 1, 3);

-- manuelle �berpr�fung
SELECT COUNT(DISTINCT(autor)) FROM �bergangstabelle;
SELECT COUNT(DISTINCT(author_id)) FROM �bergangstabelle;
SELECT autor, autor_vorname, autor_nachname, author_id FROM �bergangstabelle ORDER BY author_id;


-- Definieren der book_ID
-- Create sequence for book_IDs
-- DROP SEQUENCE book_ID_seq;
CREATE SEQUENCE book_ID_seq
START WITH 9780000000001
INCREMENT BY 1;
-- Einf�gen der book_ID_numbers in die �bergangstabelle
-- da 'Asterix der Gallier' zwei Autoren hat, wird die Zeile f�r den Zweitautor Albert Uderzo ausgelassen
UPDATE �bergangstabelle
SET book_ID = book_ID_seq.nextval
WHERE author_ID <> 'UderzAlb';
-- Einf�gen der Book_ID f�r 'Asterix der Gallier' in die ausgelassene Zeile:
UPDATE �bergangstabelle
SET book_ID = (SELECT book_id FROM �bergangstabelle WHERE author_id = 'GosciRen')
WHERE author_id = 'UderzAlb';

-- Extraction der Rezensenten-Vornamen / Erstellen der Rezensenten-ID:
UPDATE �bergangstabelle SET rezensent_vorname  = SUBSTR(rezensent, 1, INSTR(rezensent, ' ', -1));
UPDATE �bergangstabelle SET rezensent_nachname = SUBSTR(rezensent, INSTR(rezensent, ' ', -1)+1);
UPDATE �bergangstabelle SET rezensent_id = SUBSTR(rezensent_nachname, 1, 5) || SUBSTR(rezensent_vorname, 1, 3);

-- visuelle �berpr�fung der fertigen Tabelle:
SELECT * FROM �bergangstabelle;