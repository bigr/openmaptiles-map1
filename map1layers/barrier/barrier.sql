

CREATE OR REPLACE FUNCTION layer_barrier(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    barrier TEXT,
    layer INT,
    name TEXT,
    wikipedia TEXT,
    website TEXT,
    fence_type TEXT,
    height TEXT,
    stile TEXT,
    material TEXT
) AS $$
    SELECT
	osm_id, way, barrier, get_layer(layer, is_bridge, is_tunnel),
	name, wikipedia, website, fence_type, height, stile, material
    FROM barrier
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;