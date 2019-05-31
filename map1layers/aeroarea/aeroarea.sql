

CREATE OR REPLACE FUNCTION layer_aeroarea(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    aeroway TEXT,
    layer INT
    way_area REAL
) AS $$
    SELECT osm_id, way, aeroway, get_layer(layer, is_bridge, is_tunnel) AS layer, way_area
    FROM aeroarea
    WHERE way && bbox
    ORDER BY way_area DESC

$$ LANGUAGE SQL IMMUTABLE;
