
CREATE OR REPLACE FUNCTION layer_pistearea(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
	pisteway TEXT,
	layer INT,
	name TEXT
	difficulty TEXT,
	grooming TEXT,
	way_area REAL
) AS $$
    SELECT
        osm_id, way, "piste:type" AS pisteway,
        get_layer(layer, is_bridge, is_tunnel) AS layer,
        "piste:name" AS name, "piste:difficulty" AS difficulty,
        "piste:grooming" AS grooming, way_area
    FROM pistearea
    WHERE way && bbox
$$ LANGUAGE SQL IMMUTABLE;