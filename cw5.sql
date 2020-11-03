/*1*/
CREATE TABLE obiekty(
id SERIAL PRIMARY KEY,
nazwa text,
geometria geometry
);

/*a*/

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt1',
ST_COLLECT( 
        Array[
            'LINESTRING(0 1, 1 1)', 
            'CIRCULARSTRING(1 1, 2 0, 3 1)' , 
            'CIRCULARSTRING(3 1, 4 2, 5 1)' , 
            'LINESTRING(5 1, 6 1)'
        ]
        )
);

/*b*/

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt2',
ST_BuildArea(
    ST_Collect(
            Array[
                'LINESTRING(10 2, 10 6, 14 6)', 
                'CIRCULARSTRING(14 6, 16 4, 14 2)' , 
                'CIRCULARSTRING(14 2, 12 0, 10 2)' ,
                'CIRCULARSTRING(11 2, 13 2, 11 2)'
            ]
        )
    )
);

/*c*/
INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt3',
ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))',0)
);

/*d*/

INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt4',
ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)',0)
);

/*e*/
INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt5',
ST_GeomFromText('MULTIPOINT((30 30 59),(38 32 234))',0)
);

/*f*/
INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt6',
ST_GeomFromText('GEOMETRYCOLLECTION( LINESTRING(1 1, 3 2) , POINT(4 2))',0)
);


/*2*/
SELECT ST_Area(ST_buffer(ST_ShortestLine(a.geometria,b.geometria),5))
FROM obiekty a, obiekty b
WHERE a.nazwa='obiekt3' and b.nazwa='obiekt4';

/*3*/
/*Poligon jest figurą zamkniętą. musimy załatać dziurę w obiekcie 4*/

UPDATE obiekty SET geometria =
    (SELECT ST_BuildArea(ST_Collect(a.geometria,ST_GeomFromText('LINESTRING(20 20, 20.5 19.5)')))
    FROM obiekty a
    WHERE a.nazwa='obiekt4') WHERE nazwa='obiekt4';

/*4*/
INSERT INTO obiekty(nazwa, geometria) VALUES
('obiekt7',
(SELECT ST_Collect(a.geometria, b.geometria) FROM obiekty a, obiekty b WHERE a.nazwa='obiekt3' AND b.nazwa = 'obiekt4')
);

/*5 wynik będze niedokładny - figury zamknięte definiowałem jako poligony, a HasArc nie potrafi rozpozanć krzywizn w poligonie. Nie istnieje proste rzutowanie z poligonu na multiline. Musiałbym pisać funkcję obsługującą inaczej wszystkie poligony, a to nie jest chyba cel zadania*/
SELECT ST_Area(ST_Buffer(geometria,5)) FROM obiekty where not ST_HasArc(geometria);




