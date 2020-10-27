/*4*/

SELECT DISTINCT b.* INTO tableB FROM popp b, majrivers r
WHERE b.f_codedesc LIKE 'Building' AND ST_DISTANCE(b.geom,r.geom)<100000;

SELECT COUNT(*) FROM tableB;

/*5*/
/*a*/

CREATE TABLE airportsNew
(
id SERIAL PRIMARY KEY,
name TEXT,
geom geometry,
elev numeric
);

INSERT INTO airportsNew(name, geom, elev) SELECT name, geom, elev FROM airports;

CREATE TEMP TABLE twoAirports
(
id SERIAL PRIMARY KEY,
name TEXT,
geom geometry
);

INSERT INTO twoAirports(name,geom) SELECT * FROM
((SELECT name,geom FROM airportsNew 
ORDER BY ST_X(ST_centroid(geom)) LIMIT 1)
UNION ALL
(SELECT name,geom FROM airportsNew 
ORDER BY ST_X(ST_centroid(geom)) DESC LIMIT 1)) t;


/*b*/
INSERT INTO airportsNew(name, geom, elev) VALUES
('airportB',
(SELECT ST_LineInterpolatePoint(ST_ShortestLine(a.geom,b.geom),0.5)
FROM twoAirports a,twoAirports b
WHERE a.id=1 AND b.id=2)
,3);

DROP TABLE twoAirports;

/*6*/

SELECT ST_Area(ST_Buffer(ST_ShortestLine(a.geom,l.geom),1000)) FROM airports a, lakes l
WHERE a.name LIKE 'AMBLER' AND l.names LIKE 'Iliamna Lake';

/*7*/


SELECT SUM(ST_Area(ST_Intersection(t.geom, a.geom))) as areas, vegdesc 
FROM trees t, (
    SELECT geom FROM tundra 
    UNION ALL 
    SELECT geom FROM swamp) a
WHERE ST_Intersects(t.geom, a.geom)
GROUP BY t.vegdesc;
