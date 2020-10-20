/* 3*/
/*==================================================*/
CREATE EXTENSION postgis;

/* 4*/
/*==================================================*/
CREATE TABLE budynki(
id SERIAL PRIMARY KEY,
geometria GEOMETRY,
nazwa TEXT);

CREATE TABLE drogi (
id SERIAL PRIMARY KEY,
geometria GEOMETRY,
nazwa TEXT);

CREATE TABLE punkty_informacji(
id SERIAL PRIMARY KEY,
geometria GEOMETRY,
nazwa TEXT);

/* 5*/
/*==================================================*/
INSERT INTO punkty_informacji(nazwa, geometria) VALUES
('K',ST_GeomFromText('POINT(6 9.5)',0)),
('J',ST_GeomFromText('POINT(6.5 6)',0)),
('I',ST_GeomFromText('POINT(9.5 6)',0)),
('G',ST_GeomFromText('POINT(1 3.5)',0)),
('H',ST_GeomFromText('POINT(5.5 1.5)',0));

INSERT INTO drogi(nazwa, geometria) VALUES
('RoadX',ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',0)),
('RoadY',ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)',0));



INSERT INTO budynki(nazwa, geometria) VALUES
('BuildingA',ST_GeomFromText('POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4,8 1.5))',0)),
('BuildingB',ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))',0)),
('BuildingC',ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))',0)),
('BuildingD',ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))',0)),
('BuildingF',ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))',0));

/* 6*/
/*==================================================*/
/*a*/
SELECT SUM(ST_Length(geometria)) FROM drogi;

/*b*/
SELECT ST_AsText(geometria), ST_Area(geometria), ST_Length(ST_ExteriorRing(geometria))
FROM budynki WHERE nazwa LIKE 'BuildingA';

/*c*/
SELECT nazwa, ST_Area(geometria) FROM budynki
ORDER BY nazwa;

/*d*/
SELECT nazwa, ST_Length(ST_ExteriorRing(geometria)) FROM budynki
ORDER BY ST_Area(geometria) DESC
LIMIT 2;

/*e*/
SELECT ST_Distance(a.geometria, b.geometria) 
FROM budynki a, punkty_informacji b
WHERE a.nazwa LIKE 'BuildingC' AND b.nazwa LIKE 'G';

/*f*/
SELECT ST_Area(c.geometria) - ST_Area(ST_Intersection(ST_Buffer(b.geometria, 0.5),c.geometria))
FROM budynki b, budynki c
WHERE b.nazwa LIKE 'BuildingB'
AND c.nazwa LIKE 'BuildingC';

/*g*/
SELECT a.nazwa FROM budynki a, (SELECT geometria FROM drogi WHERE nazwa LIKE 'RoadX') b
WHERE ST_Y(ST_Centroid(a.geometria))>ST_Y(ST_Centroid(b.geometria));


/* 8*/
/*==================================================*/
SELECT ST_Area(a.geometria)+ST_Area(b)-ST_Area(ST_Intersection(a.geometria,b)) AS pole
FROM budynki a, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0) b
WHERE a.nazwa LIKE 'BuildingC';
