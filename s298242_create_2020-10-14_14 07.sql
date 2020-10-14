-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-10-14 12:01:06.38
CREATE SCHEMA sklep;

GRANT USAGE ON SCHEMA sklep TO ksiegowosc;
GRANT SELECT ON ALL TABLES IN SCHEMA sklep TO ksiegowosc;
ALTER DEFAULT PRIVILEGES IN SCHEMA sklep GRANT SELECT ON TABLES TO ksiegowosc;
GRANT ALL ON SCHEMA sklep TO write_user;

-- tables
-- Table: Zamowienia
CREATE TABLE sklep.Zamowienia (
    id_zamowienia serial  NOT NULL,
    id_produktu int  NOT NULL,
    ilosc int  NOT NULL,
    data date  NOT NULL,
    CONSTRAINT Zamowienia_pk PRIMARY KEY (id_zamowienia)
);

-- Table: godziny
CREATE TABLE firma.godziny (
    id_godziny serial  NOT NULL,
    data date  NOT NULL,
    liczba_godzin integer  NOT NULL,
    id_pracownika integer  NOT NULL,
    id_wynagrodzenie integer  NULL,
    CONSTRAINT godziny_pk PRIMARY KEY (id_godziny)
);

-- Table: pensja_stanowisko
CREATE TABLE firma.pensja_stanowisko (
    id_pensji serial  NOT NULL,
    stanowisko text  NULL,
    kwota real  NOT NULL,
    CONSTRAINT pensja_stanowisko_pk PRIMARY KEY (id_pensji)
);

-- Table: pracownicy
CREATE TABLE firma.pracownicy (
    id_pracownika serial  NOT NULL,
    imie text  NOT NULL,
    nazwisko text  NOT NULL,
    adres text  NOT NULL,
    telefon text  NOT NULL,
    CONSTRAINT pracownicy_pk PRIMARY KEY (id_pracownika)
);

CREATE INDEX imie_idx on firma.pracownicy (imie ASC);

CREATE INDEX nazwisko_idx on firma.pracownicy (nazwisko ASC);

-- Table: premia
CREATE TABLE firma.premia (
    id_premii serial  NOT NULL,
    rodzaj text  NULL,
    kwota real  NOT NULL,
    CONSTRAINT premia_pk PRIMARY KEY (id_premii)
);

-- Table: producenci
CREATE TABLE sklep.producenci (
    id_producenta serial  NOT NULL,
    nazwa_producenta text  NOT NULL,
    mail text  NOT NULL,
    telefon text  NOT NULL,
    CONSTRAINT producenci_pk PRIMARY KEY (id_producenta)
);

-- Table: produkty
CREATE TABLE sklep.produkty (
    id_produktu serial  NOT NULL,
    nazwa_produktu text  NOT NULL,
    cena money  NOT NULL,
    id_producenta int  NOT NULL,
    CONSTRAINT produkty_pk PRIMARY KEY (id_produktu)
);

-- Table: wynagrodzenie
CREATE TABLE firma.wynagrodzenie (
    id_wynagrodzenia serial  NOT NULL,
    data date  NOT NULL,
    id_pracownika integer  NOT NULL,
    id_pensji integer  NOT NULL,
    id_premii integer  NULL,
    CONSTRAINT wynagrodzenie_pk PRIMARY KEY (id_wynagrodzenia)
);

-- foreign keys
-- Reference: FK_GodzinyPracownicy (table: godziny)
ALTER TABLE firma.godziny ADD CONSTRAINT FK_GodzinyPracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_GodzinyWynagrodzenie (table: godziny)
ALTER TABLE firma.godziny ADD CONSTRAINT FK_GodzinyWynagrodzenie
    FOREIGN KEY (id_wynagrodzenie)
    REFERENCES firma.wynagrodzenie (id_wynagrodzenia)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_WynagrodzeniePensja (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT FK_WynagrodzeniePensja
    FOREIGN KEY (id_pensji)
    REFERENCES firma.pensja_stanowisko (id_pensji)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_WynagrodzeniePracownicy (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT FK_WynagrodzeniePracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_WynagrodzeniePremia (table: wynagrodzenie)
ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT FK_WynagrodzeniePremia
    FOREIGN KEY (id_premii)
    REFERENCES firma.premia (id_premii)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: producenci_produkty (table: produkty)
ALTER TABLE sklep.produkty ADD CONSTRAINT producenci_produkty
    FOREIGN KEY (id_producenta)
    REFERENCES sklep.producenci (id_producenta)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: produkty_Zamowienia (table: Zamowienia)
ALTER TABLE sklep.Zamowienia ADD CONSTRAINT produkty_Zamowienia
    FOREIGN KEY (id_produktu)
    REFERENCES sklep.produkty (id_produktu)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;
-- End of file.

