

CREATE OR REPLACE FUNCTION layer_waterway2(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    waterway TEXT,
    name TEXT,
    layer INT
) AS $$
    SELECT
        osm_id, way, waterway, name,
        get_layer(layer, is_bridge, is_tunnel) as layer
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;