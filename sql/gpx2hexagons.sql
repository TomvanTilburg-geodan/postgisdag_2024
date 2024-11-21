CREATE SCHEMA IF NOT EXISTS h3;
DROP TABLE IF EXISTS h3.gpx_hexagons;
CREATE TABLE h3.gpx_hexagons AS
WITH points AS (
   	SELECT ST_Transform((ST_Dumppoints(ST_Segmentize(wkb_geometry,10))).geom, 4326) AS geom
	FROM gpx.tracks
)
SELECT 
h3_cell_to_boundary_geometry(h3_lat_lng_to_cell(geom::point,9)) AS h3,
COUNT(*) AS count
FROM points
GROUP BY h3
