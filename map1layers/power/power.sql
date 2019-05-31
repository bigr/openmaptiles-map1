

CREATE OR REPLACE FUNCTION get_power_grade(power)
RETURNS INT $$
    SELECT CASE
        WHEN power = 'line' THEN 1
        WHEN power = 'minor_line' THEN 2
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_power(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
	power TEXT,
	layer INT,
	grade INT,
	name TEXT,
	note TEXT,
	line TEXT,
	length TEXT,
	location TEXT,
	voltage TEXT,
	cables TEXT,
	wires TEXT,
	frequency TEXT,
	operator TEXT,
	is_bridge BOOLEAN,
	is_tunnel BOOLEAN,
) AS $$
    SELECT
	    way, osm_id, power, get_layer(layer, is_bridge, is_tunnel) AS layer, get_power_grade(grade) AS grade,
	    name, note, line, length, location, voltage, cables, wires, frequency, operator, is_bridge, is_tunnel
    FROM power
    WHERE
            power IS NOT NULL
        AND way && bbox

$$ LANGUAGE SQL IMMUTABLE;