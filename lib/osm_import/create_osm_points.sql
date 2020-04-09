COPY
(SELECT
osm_id AS original_id
, "addr:housename" AS housename
, "addr:housenumber" AS housenumber
, name
, brand
, denomination
, building
, amenity
, shop
, operator
, tags -> 'addr:street' AS street
, tags -> 'addr:city' AS city
, tags -> 'addr:country' AS country
, tags -> 'addr:district' AS district
, tags -> 'addr:postcode' AS zip_code
, tags -> 'addr:place' AS place
, tags -> 'opening_hours' AS opening_hours
, ST_Y(ST_Transform (way, 4326)) AS latitude
, ST_X(ST_Transform (way, 4326)) AS longitude
, way AS geom 
, CURRENT_TIMESTAMP as created_at
, CURRENT_TIMESTAMP as updated_at
    FROM planet_osm_point
UNION ALL
SELECT 
osm_id AS original_id
, "addr:housename" AS housename
, "addr:housenumber" AS housenumber
, name
, brand
, denomination
, building
, amenity
, shop
, operator
, tags -> 'addr:street' AS street
, tags -> 'addr:city' AS city
, tags -> 'addr:country' AS country
, tags -> 'addr:district' AS district
, tags -> 'addr:postcode' AS zip_code
, tags -> 'addr:place' AS place
, tags -> 'opening_hours' AS opening_hours
, ST_Y(ST_Transform(ST_Centroid(way), 4326)) AS latitude 
, ST_X(ST_Transform(ST_Centroid(way), 4326)) AS longitude
, ST_Centroid(way) AS geom
, CURRENT_TIMESTAMP as created_at
, CURRENT_TIMESTAMP as updated_at
    FROM planet_osm_polygon)
    TO STDOUT
 WITH CSV HEADER DELIMITER ',';