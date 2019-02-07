/* Befüllen der Haupttabellen */

-- Befüllen der Autoren-Tabelle
INSERT INTO autoren
SELECT 
    DISTINCT author_id,
    autor_vorname,
    autor_nachname,
    sprache
FROM übergangstabelle;
-- Test:
SELECT * FROM autoren WHERE vorname IS NULL ORDER BY author_ID;

-- Befüllen der Authoren_zu_Buecher-Tabelle:
-- Erzeugen einer Sequenz für den Primärschlüssel:
CREATE SEQUENCE autoren_zu_buecher_schlüssel_seq
START WITH 1
INCREMENT BY 1;
-- Einfügen der Werte:
INSERT INTO autoren_zu_buecher
SELECT
    autoren_zu_buecher_schlüssel_seq.nextval,
    author_id,
    book_id
FROM übergangstabelle;
-- Ansehen des Ergebnisses:
SELECT * FROM autoren_zu_buecher;


-- Befüllen der Buecher-Tabelle
INSERT INTO buecher
SELECT
    DISTINCT book_id,
    titel,
    jahr1,
    jahr2
FROM übergangstabelle ORDER BY book_id;
-- Test
SELECT * FROM buecher;

-- Befüllen der BBC Tabelle
INSERT INTO BBC
SELECT
    nummer_bbc,
    book_id,
    originaltitel
FROM übergangstabelle WHERE nummer_BBC IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM BBC;


-- Befüllen der Karasek Tabelle
INSERT INTO karasek
SELECT
    nummer_karasek,
    book_id,
    beschreibung
FROM übergangstabelle WHERE nummer_karasek IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM karasek;


-- Befüllen der LeMonde Tabelle:
INSERT INTO lemonde
SELECT
    DISTINCT nummer_lemonde,
    book_id,
    NULL
FROM übergangstabelle WHERE nummer_lemonde IS NOT NULL;
-- hinzufügen der Originaltitel für Bücher von französischsprachigen Autoren:
UPDATE lemonde outer_table
SET outer_table.originaltitel =
    (   SELECT inner_table.originaltitel
        FROM übergangstabelle inner_table
        WHERE inner_table.book_id = outer_table.book_id
        AND inner_table.sprache = 'Französisch'
        AND inner_table.autor != 'Albert Uderzo' );
-- Ergebnis ansehen:
SELECT * from lemonde;


-- Befüllen der ZEIT Tabelle:
INSERT INTO zeit
SELECT
    nummer_zeit,
    book_id,
    rezensent_ID
FROM übergangstabelle WHERE nummer_zeit IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM zeit;


-- Befüllen der ZEIT Rezensenten:
INSERT INTO zeit_rezensenten
SELECT
    DISTINCT rezensent_id,
    rezensent_vorname,
    rezensent_nachname
FROM übergangstabelle WHERE rezensent IS NOT NULL;
-- Ergebnis ansehen:
SELECT * FROM zeit_rezensenten;