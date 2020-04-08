DROP TABLE IF EXISTS osm_points;

CREATE TABLE osm_points AS
SELECT 
"addr:housename" AS housename
, "addr:housenumber" AS housenumber
, name
, brand
, denomination
, building
, amenity
, shop
, ST_Y(ST_Transform (way, 4326)) AS latitude 
, ST_X(ST_Transform (way, 4326)) AS longitude
, way AS geom 
, CURRENT_TIMESTAMP as created_at
, CURRENT_TIMESTAMP as updated_at
	FROM planet_osm_point
UNION ALL
SELECT 
"addr:housename" AS housename
, "addr:housenumber" AS housenumber
, name
, brand
, denomination
, building
, amenity
, shop
, ST_Y(ST_Transform(ST_Centroid(way), 4326)) AS latitude 
, ST_X(ST_Transform(ST_Centroid(way), 4326)) AS longitude
, ST_Centroid(way) AS geom
, CURRENT_TIMESTAMP as created_at
, CURRENT_TIMESTAMP as updated_at
	FROM planet_osm_polygon;