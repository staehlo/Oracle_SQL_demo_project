/* Diverse Abfragen-Beispiele */

-- Skript 20: Verletzung der Normalform durch redundante Daten:
SELECT au.vorname, au.nachname
FROM autoren au JOIN zeit_rezensenten ze
ON author_id = rezensent_id;

-- Skript 21: Bücher, die sowohl von der ZEIT wie auch von Hellmuth Karasek vorgeschlagen wurden:
SELECT
    bu.titel,
    au.vorname AS "Autor_Vorname(n)",
    au.nachname AS "Autor_Nachname"
FROM buecher bu
INNER JOIN autoren_zu_buecher ab ON ab.book_id = bu.book_id
INNER JOIN autoren au ON au.author_id = ab.author_id
WHERE
    bu.book_id IN (SELECT book_ID FROM karasek)
    AND
    bu.book_id IN (SELECT book_ID FROM zeit)
ORDER BY bu.titel;

-- Skript 22: Autoren, sortiert nach Anzahl der empfohlener Bücher
SELECT
    au.vorname,
    au.nachname,
    COUNT(bu.book_id) Anzahl
FROM buecher bu
INNER JOIN autoren_zu_buecher ab ON ab.book_id = bu.book_id
INNER JOIN autoren au ON au.author_id = ab.author_id
GROUP BY au.author_id, au.vorname, au.nachname
ORDER BY anzahl DESC, au.nachname;

-- Skript 23: Bücher von Charles Dickens
SELECT
    au.vorname,
    au.nachname,
    bu.titel
FROM buecher bu
INNER JOIN autoren_zu_buecher ab ON ab.book_id = bu.book_id
INNER JOIN autoren au ON au.author_id = ab.author_id
WHERE nachname = 'Dickens'
ORDER BY titel;