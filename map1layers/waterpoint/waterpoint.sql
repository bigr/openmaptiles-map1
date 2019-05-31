
CREATE OR REPLACE FUNCTION layer_waterpoint(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    waterway TEXT,
    layer INT,
    name TEXT
) AS $$
    SELECT
        osm_id, way, waterway, get_layer(layer, is_bridge, is_tunnel) as layer, name
    FROM waterpoint
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;