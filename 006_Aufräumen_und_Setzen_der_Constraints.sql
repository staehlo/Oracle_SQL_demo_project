/* Löschen von nicht mehr benötigten Tabellen und Erstellen der Schlüssel und Verknüpfungen */

-- Löschen von nicht mehr benötigten Objekten:
-- Tabellen:
select 'drop table '||table_name||' cascade constraints;' from user_tables ORDER BY table_name;
drop table HILFSTABELLE_BBC cascade constraints;
drop table HILFSTABELLE_KARASEK cascade constraints;
drop table HILFSTABELLE_LEMONDE cascade constraints;
drop table HILFSTABELLE_LEMONDE_FR cascade constraints;
drop table HILFSTABELLE_ZEIT cascade constraints;
drop table ÜBERGANGSTABELLE cascade constraints;
-- Sequenzen:
SELECT 'drop sequence ' || sequence_name || ';' FROM user_sequences;
drop sequence AUTOREN_ZU_BUECHER_SCHLÜSSEL_SEQ;
drop sequence BOOK_ID_SEQ;


-- Festlegung der Primary Keys:
ALTER TABLE autoren ADD CONSTRAINT autoren_pk PRIMARY KEY (author_id);
ALTER TABLE autoren_zu_buecher ADD CONSTRAINT autoren_zu_buecher_pk PRIMARY KEY (schlüssel);
ALTER TABLE buecher ADD CONSTRAINT buecher_pk PRIMARY KEY (book_id);
ALTER TABLE bbc ADD CONSTRAINT bbc_pk PRIMARY KEY (nummer);
ALTER TABLE karasek ADD CONSTRAINT karasek_pk PRIMARY KEY (nummer);
ALTER TABLE lemonde ADD CONSTRAINT lemonde_pk PRIMARY KEY (nummer);
ALTER TABLE zeit ADD CONSTRAINT zeit_pk PRIMARY KEY (nummer);
ALTER TABLE zeit_rezensenten ADD CONSTRAINT zeit_rezensenten_pk PRIMARY KEY (rezensent_ID);

-- Festlegung der Foreign Keys:
ALTER TABLE autoren_zu_buecher ADD CONSTRAINT autoren_zu_buecher_author_id_fk FOREIGN KEY (author_id) REFERENCES autoren(author_id);
ALTER TABLE autoren_zu_buecher ADD CONSTRAINT autoren_zu_buecher_book_id_fk FOREIGN KEY (book_id) REFERENCES buecher(book_id);
ALTER TABLE bbc ADD CONSTRAINT bbc_book_id_fk FOREIGN KEY (book_id) REFERENCES buecher(book_id);
ALTER TABLE karasek ADD CONSTRAINT karasek_book_id_fk FOREIGN KEY (book_id) REFERENCES buecher(book_id);
ALTER TABLE lemonde ADD CONSTRAINT lemonde_book_id_fk FOREIGN KEY (book_id) REFERENCES buecher(book_id);
ALTER TABLE zeit ADD CONSTRAINT zeit_book_id_fk FOREIGN KEY (book_id) REFERENCES buecher(book_id);
ALTER TABLE zeit ADD CONSTRAINT zeit_rezensent_id_fk FOREIGN KEY (rezensent_id) REFERENCES zeit_rezensenten(rezensent_id);