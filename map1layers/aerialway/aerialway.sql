


CREATE OR REPLACE FUNCTION layer_aerialway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        aerialway TEXT,
        "piste:lift" TEXT,
        layer INT,
        name TEXT
) AS $$
    SELECT
        osm_id, way, aerialway, COALESCE("piste:lift",'no') AS "piste:lift",
        get_layer(layer, is_bridge, is_tunnel) as layer, name
    FROM aerialway
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;