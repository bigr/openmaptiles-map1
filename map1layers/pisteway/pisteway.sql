

CREATE OR REPLACE FUNCTION layer_pisteway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
	pisteway TEXT,
	layer INT,
	name TEXT
	difficulty TEXT,
	grooming TEXT
) AS $$
    SELECT
        osm_id, way, "piste:type" AS pisteway,
        get_layer(layer, is_bridge, is_tunnel) AS layer,
        "piste:name" AS name, "piste:difficulty" AS difficulty,
        "piste:grooming" AS grooming
    FROM pisteway
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;