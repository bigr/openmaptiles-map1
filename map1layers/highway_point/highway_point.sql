
CREATE OR REPLACE FUNCTION layer_highway_point(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        highway TEXT,
        ref TEXT,
        name TEXT

) AS $$
    SELECT osm_id, way, highway, ref, name
    FROM highway_point
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;