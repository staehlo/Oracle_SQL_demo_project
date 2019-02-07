/* Bef�llen der Haupttabellen */

-- Bef�llen der Autoren-Tabelle
INSERT INTO autoren
SELECT 
    DISTINCT author_id,
    autor_vorname,
    autor_nachname,
    sprache
FROM �bergangstabelle;
-- Test:
SELECT * FROM autoren WHERE vorname IS NULL ORDER BY author_ID;

-- Bef�llen der Authoren_zu_Buecher-Tabelle:
-- Erzeugen einer Sequenz f�r den Prim�rschl�ssel:
CREATE SEQUENCE autoren_zu_buecher_schl�ssel_seq
START WITH 1
INCREMENT BY 1;
-- Einf�gen der Werte:
INSERT INTO autoren_zu_buecher
SELECT
    autoren_zu_buecher_schl�ssel_seq.nextval,
    author_id,
    book_id
FROM �bergangstabelle;
-- Ansehen des Ergebnisses:
SELECT * FROM autoren_zu_buecher;


-- Bef�llen der Buecher-Tabelle
INSERT INTO buecher
SELECT
    DISTINCT book_id,
    titel,
    jahr1,
    jahr2
FROM �bergangstabelle ORDER BY book_id;
-- Test
SELECT * FROM buecher;

-- Bef�llen der BBC Tabelle
INSERT INTO BBC
SELECT
    nummer_bbc,
    book_id,
    originaltitel
FROM �bergangstabelle WHERE nummer_BBC IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM BBC;


-- Bef�llen der Karasek Tabelle
INSERT INTO karasek
SELECT
    nummer_karasek,
    book_id,
    beschreibung
FROM �bergangstabelle WHERE nummer_karasek IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM karasek;


-- Bef�llen der LeMonde Tabelle:
INSERT INTO lemonde
SELECT
    DISTINCT nummer_lemonde,
    book_id,
    NULL
FROM �bergangstabelle WHERE nummer_lemonde IS NOT NULL;
-- hinzuf�gen der Originaltitel f�r B�cher von franz�sischsprachigen Autoren:
UPDATE lemonde outer_table
SET outer_table.originaltitel =
    (   SELECT inner_table.originaltitel
        FROM �bergangstabelle inner_table
        WHERE inner_table.book_id = outer_table.book_id
        AND inner_table.sprache = 'Franz�sisch'
        AND inner_table.autor != 'Albert Uderzo' );
-- Ergebnis ansehen:
SELECT * from lemonde;


-- Bef�llen der ZEIT Tabelle:
INSERT INTO zeit
SELECT
    nummer_zeit,
    book_id,
    rezensent_ID
FROM �bergangstabelle WHERE nummer_zeit IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM zeit;


-- Bef�llen der ZEIT Rezensenten:
INSERT INTO zeit_rezensenten
SELECT
    DISTINCT rezensent_id,
    rezensent_vorname,
    rezensent_nachname
FROM �bergangstabelle WHERE rezensent IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM zeit_rezensenten;