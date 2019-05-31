


CREATE OR REPLACE FUNCTION layer_building(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    building TEXT,
    name TEXT,
    walls TEXT,
    hight TEXT,
    description TEXT,
    levels TEXT,
    way_area REAL,
    centroid GEOMETRY
) AS $$
    SELECT
		way, osm_id, building, name,
        COALESCE(wall,"building:walls") AS walls,
		COALESCE(height,"building:height") AS height,
		description, "building:levels" AS levels,
		way_area, ST_Centroid(way) AS centroid
	FROM building
    WHERE
            building IS NOT NULL
        AND building NOT IN ('bridge','tunnel')
        AND NOT is_bridge
        AND NOT is_tunnel
        AND way && bbox
    ORDER BY way_area DESC

$$ LANGUAGE SQL IMMUTABLE;