

CREATE OR REPLACE FUNCTION layer_barrierpoint(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    layer INT,
    name TEXT
) AS $$
    SELECT osm_id, way, barrier, get_layer(layer, is_bridge, is_tunnel), name
    FROM barrierpoint
    WHERE way && bbox
$$ LANGUAGE SQL IMMUTABLE;