/* Aufbereitung der Hilfstabellen */

-- Die Excel-Import-Funktion des SQL-Developers akzeptiert nur Daten im CHAR oder VARCHAR2-Format.
-- Deshalb wurden auch die Jahreszahlen und Rangnummern als Text-Daten hochgeladen.
-- Diese Spalten m�ssen jetzt abge�ndert werden.

-- Hilfstabelle_BBC
DESC hilfstabelle_bbc;
-- Transfer Platz-Nummern in die neue Spalte
UPDATE hilfstabelle_bbc SET nummer = TO_NUMBER(nummer_import);
UPDATE hilfstabelle_bbc SET jahr1 = TO_NUMBER(jahr1_import);
UPDATE hilfstabelle_bbc SET jahr2 = TO_NUMBER(jahr2_import);
-- L�schen der nicht mehr ben�tigten Spalten
ALTER TABLE hilfstabelle_bbc DROP COLUMN nummer_import;
ALTER TABLE hilfstabelle_bbc DROP COLUMN jahr1_import;
ALTER TABLE hilfstabelle_bbc DROP COLUMN jahr2_import;
-- Ersetzen der '-' Eintr�ge in der Titel-Spalte durch NULL
UPDATE hilfstabelle_bbc
SET deutscher_titel = NULL
WHERE deutscher_titel = '-';
-- Check result:
SELECT * FROM hilfstabelle_bbc;


-- Hilfstabelle_Karasek
DESC Hilfstabelle_Karasek;
-- Transfer der Nummerierung in Zeile mit NUMBER-Format:
UPDATE hilfstabelle_karasek SET nummer = TO_NUMBER(nummer_import);
ALTER TABLE hilfstabelle_karasek DROP COLUMN nummer_import;
SELECT * FROM hilfstabelle_karasek;

-- Hilfstabelle_LeMonde
DESC Hilfstabelle_LeMonde;
UPDATE hilfstabelle_lemonde SET nummer = TO_NUMBER(nummer_import);
UPDATE hilfstabelle_lemonde SET jahr1 = TO_NUMBER(jahr1_import);
UPDATE hilfstabelle_lemonde SET jahr2 = TO_NUMBER(jahr2_import);
ALTER TABLE hilfstabelle_lemonde DROP COLUMN nummer_import;
ALTER TABLE hilfstabelle_lemonde DROP COLUMN jahr1_import;
ALTER TABLE hilfstabelle_lemonde DROP COLUMN jahr2_import;
SELECT * FROM hilfstabelle_lemonde;

-- Hilfstabelle_LeMonde_FR
DESC hilfstabelle_lemonde_fr;
UPDATE hilfstabelle_lemonde_fr SET no = TO_NUMBER(no_import);
UPDATE hilfstabelle_lemonde_fr SET ann�e1 = TO_NUMBER(ann�e1_import);
UPDATE hilfstabelle_lemonde_fr SET ann�e2 = TO_NUMBER(ann�e2_import);
ALTER TABLE hilfstabelle_lemonde_fr DROP COLUMN no_import;
ALTER TABLE hilfstabelle_lemonde_fr DROP COLUMN ann�e1_import;
ALTER TABLE hilfstabelle_lemonde_fr DROP COLUMN ann�e2_import;
SELECT * FROM hilfstabelle_lemonde_fr;

-- Hilfstabelle_Zeit
DESC hilfstabelle_zeit;
UPDATE hilfstabelle_zeit SET nummer = TO_NUMBER(nummer_import);
UPDATE hilfstabelle_zeit SET jahr1 = TO_NUMBER(jahr1_import);
UPDATE hilfstabelle_zeit SET jahr2 = TO_NUMBER(jahr2_import);
ALTER TABLE hilfstabelle_zeit DROP COLUMN nummer_import;
ALTER TABLE hilfstabelle_zeit DROP COLUMN jahr1_import;
ALTER TABLE hilfstabelle_zeit DROP COLUMN jahr2_import;
SELECT * FROM hilfstabelle_zeit;