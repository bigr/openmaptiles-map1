

CREATE OR REPLACE FUNCTION layer_landcover_line(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        natural TEXT,
        wood TEXT,
        name TEXT,
        wikipedia TEXT,
        website TEXT
) AS $$
    SELECT
        osm_id, way, natural, wood, name, wikipedia, website
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;