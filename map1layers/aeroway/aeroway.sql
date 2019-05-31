

CREATE OR REPLACE FUNCTION layer_aeroway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    aeroway TEXT,
    layer INT
) AS $$
    SELECT osm_id, way, aeroway, get_layer(layer, is_bridge, is_tunnel) as layer
    FROM aeroway
    WHERE way && bbox
$$ LANGUAGE SQL IMMUTABLE;