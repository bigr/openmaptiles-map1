
CREATE OR REPLACE FUNCTION layer_landcover(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    landuse TEXT,
    natural TEXT,
    leisure TEXT,
    amenity TEXT,
    place TEXT,
    sport TEXT,
    power TEXT,
    tourism TEXT,
    historic TEXT,
    wood TEXT,
    religion TEXT,
    name TEXT,
    way_area REAL,
    wikipedia TEXT,
    website TEXT,
    ele TEXT,
    type TEXT,
    attribution TEXT,
    species TEXT,
    operator TEXT,
    centroid GEOMETRY
) AS $$
    SELECT
    	osm_id, way, landuse, natural, leisure, amenity, place, sport, power, tourism, historic, wood, religion, name,
		way_area, ST_Centroid(way) AS centroid, wikipedia, website, ele, type, attribution, species, operator
	FROM landcover
	WHERE
            building IS NULL
        AND way && bbox
    ORDER BY way_area DESC
$$ LANGUAGE SQL IMMUTABLE;