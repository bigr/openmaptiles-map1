
CREATE OR REPLACE FUNCTION layer_aerialpoint(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        aerialway TEXT,
        "piste:lift" TEXT,
        layer INT,
        name TEXT
) AS $$
    SELECT
        way, osm_id, aerialway, COALESCE("piste:lift",'no') AS "piste:lift",
        (get_layer(layer, is_bridge, is_tunnel) - 1) AS layer,
    FROM aerialpoint
    WHERE aerialway IN ('pylon') AND way && bbox
$$ LANGUAGE SQL IMMUTABLE;