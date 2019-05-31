

CREATE OR REPLACE FUNCTION layer_powerpoint(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
	power TEXT,
	layer INT,
	name TEXT,
	ref TEXT,
	material TEXT,
	structure TEXT,
	height TEXT,
	colour TEXT,
	"tower:type" TEXT,
	design TEXT,
	"design:name" TEXT,
	"design:incomplete" TEXT
) AS $$
    SELECT
	    osm_id, way, power, get_layer(layer, is_bridge, is_tunnel) AS layer, name, ref, material, structure,
	    height, colour, "tower:type", design, "design:name", "design:incomplete"
	FROM powerpoint
    WHERE
            power IN ('pole','tower')
        AND osm_id > 0
        AND way && bbox

$$ LANGUAGE SQL IMMUTABLE;