/* Create tables for schema */

-- Erstellung der Haupttabellen
CREATE TABLE Autoren(
    author_ID   CHAR(12),
    Vorname     VARCHAR2(50),
    Nachname    VARCHAR2(25) NOT NULL,
    Sprache     VARCHAR2(15));
-- author_id soll später der primary key werden

CREATE TABLE Autoren_zu_Buecher(
    Schlüssel   NUMBER(3),
    author_id   CHAR(12),
    book_ID     NUMBER(13));
-- Schlüssel soll später der primary key werden.
    
CREATE TABLE Buecher(
    book_ID     NUMBER(13),
    Titel       VARCHAR2(200),
    Erscheinungsjahr1   NUMBER(4),
    Erscheinungsjahr2   NUMBER(4));
-- contraints:
-- mock_ISBN = primary key
-- CONSTRAINT buecher_author_id_fk FOREIGN KEY (author_id)
-- REFERENCES autoren(author_id));

CREATE TABLE BBC(
    Nummer      NUMBER(3),
    book_ID     NUMBER(13),
    Originaltitel   VARCHAR(200));
--    CONSTRAINT bbc_mock_ISBN_fk FOREIGN KEY (mock_ISBN)
--    REFERENCES buecher(mock_ISBN));
--  Rang = primary Key

CREATE TABLE Karasek(
    Nummer      NUMBER(2),
    book_ID     NUMBER(13),
    Beschreibung    VARCHAR2(1000));
--    CONSTRAINT karasek_mock_ISBN_fk FOREIGN KEY (mock_ISBN)
--    REFERENCES buecher(mock_ISBN));
--  Rang = primary Key

CREATE TABLE LeMonde(
    Nummer      NUMBER(3),
    book_ID     NUMBER(13),
    Originaltitel   VARCHAR(200));
--    CONSTRAINT lemonde_mock_ISBN_fk FOREIGN KEY (mock_ISBN)
--    REFERENCES buecher(mock_ISBN));
--  Rang = primary Key

CREATE TABLE Zeit(
    Nummer      NUMBER(3),
    book_ID     NUMBER(13),
    rezensent_ID   CHAR(12));
--    CONSTRAINT zeit_mock_ISBN_fk FOREIGN KEY (mock_ISBN)
--    REFERENCES buecher(mock_ISBN));
--    CONSTRAINT zeit_rezensent_ID_fk FOREIGN KEY (rezensent_ID)
--    REFERENCES zeit_rezensenten(rezensent_id));
--  Rang = primary Key

CREATE TABLE Zeit_Rezensenten(
    rezensent_ID    CHAR(12),
    Vorname     VARCHAR2(25),
    Nachname    VARCHAR2(25) NOT NULL);
-- rezensent_id = primary key

-- Erstellen der Hilfstabellen für den Datenimport
CREATE TABLE Hilfstabelle_BBC(
    Nummer_import   CHAR(3),
    Nummer          NUMBER(3),
    Originaltitel   VARCHAR2(200),
    Deutscher_Titel VARCHAR2(200),
    Autor           VARCHAR2(100),
    Jahr1_import    CHAR(4),
    Jahr2_import    CHAR(4),    
    Jahr1   CHAR(4),
    Jahr2   CHAR(4),
    Sprache     VARCHAR2(15));

CREATE TABLE Hilfstabelle_Karasek(
    Nummer_import   CHAR(2),
    Nummer      NUMBER(2),
    Titel       VARCHAR2(200),
    Beschreibung    VARCHAR2(1000),
    Autor       VARCHAR2(100),
    Sprache     VARCHAR2(15));

CREATE TABLE Hilfstabelle_LeMonde(
    Nummer_import   CHAR(3),
    Nummer  NUMBER(3),
    Titel       VARCHAR2(200),
    Autor       VARCHAR2(100),
    Jahr1_import    CHAR(4),
    Jahr2_import    CHAR(4),    
    Jahr1       CHAR(4),
    Jahr2       CHAR(4),
    Sprache     VARCHAR2(15));

CREATE TABLE Hilfstabelle_LeMonde_FR(
    No_import   CHAR(3),
    No          NUMBER(3),
    Titre       VARCHAR2(200),
    Auteur      VARCHAR2(100),
    Année1_import   CHAR(4),
    Année2_import   CHAR(4),
    Année1      NUMBER(4),
    Année2      NUMBER(4));

CREATE TABLE Hilfstabelle_Zeit(
    Nummer_import   CHAR(3),
    Nummer  NUMBER(3),
    Autor   VARCHAR2(200),
    Titel   VARCHAR2(1000),
    Jahr1_import    CHAR(4),
    Jahr2_import    CHAR(4),    
    Jahr1   NUMBER(4),
    Jahr2   NUMBER(4),
    Rezensent   VARCHAR(100),
    Sprache     VARCHAR2(15));

-- Erstellung der Übergangstabelle
CREATE TABLE ÜBERGANGSTABELLE(
    Titel       VARCHAR2(200),
    book_id     NUMBER(13),
    Originaltitel   VARCHAR2(200),
    Autor       VARCHAR2(100),
    Autor_Vorname   VARCHAR2(50),
    Autor_Nachname  VARCHAR2(25),
    author_id   char(12),
    Sprache     VARCHAR2(15),
    Jahr1       NUMBER(4),
    Jahr2       NUMBER(4),
    Nummer_Karasek    NUMBER(2),
    Nummer_Zeit       NUMBER(3),
    Nummer_LeMonde    NUMBER(3),
    Nummer_BBC        NUMBER(3),
    Beschreibung    VARCHAR2(1000),
    Rezensent       VARCHAR2(100),
    Rezensent_Vorname   VARCHAR2(50),
    Rezensent_Nachname  VARCHAR2(25),
    rezensent_ID    char(12));

-- Überprüfen, ob alle Tabellen vorhanden sind:
SELECT table_name from all_tables where owner = 'BK';

-- select 'drop table '||table_name||' cascade constraints;' from user_tables;