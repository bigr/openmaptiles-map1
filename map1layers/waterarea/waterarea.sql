

CREATE OR REPLACE FUNCTION layer_waterarea(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    waterway TEXT,
    landuse TEXT,
    "natural" TEXT,
    name TEXT,
    layer INT,
    is_artificial BOOLEAN,
    wikipedia TEXT,
    website TEXT,
    wetland TEXT,
    way_area REAL,
    centroid GEOMETRY
) AS $$
    SELECT
        osm_id, way, waterway, landuse, "natural", name, get_layer(layer, is_bridge, is_tunnel) as layer,
		(CASE
			WHEN waterway IN ('dock','dam') or landuse IN ('basin','reservoir') THEN TRUE
			ELSE FALSE
		END) AS
	    is_artificial,
	    wikipedia, website, wetland, way_area, ST_Centroid(way) AS centroid
	FROM waterarea
    WHERE
	        building IS NULL
        AND way && bbox
    ORDER BY way_area DESC
$$ LANGUAGE SQL IMMUTABLE;