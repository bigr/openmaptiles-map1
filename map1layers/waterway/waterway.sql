
CREATE OR REPLACE FUNCTION get_waterway_grade(waterway TEXT, name TEXT, length REAL)
RETURNS INT AS $$
    SELECT CASE
		WHEN waterway = 'stream' AND name IS NULL THEN 1
		ELSE floor(least(35,greatest(5,log(length)*7-17)))::INT
	END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_waterway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        wateray TExT,
        grade REAL,
        grade_total REAL,
        is_artificial BOOLEAN,
        is_bridge BOOLEAN,
        is_tunnel BOOLEAN,
        layer INT,
        way_length REAL,
) AS $$
    SELECT
        osm_id, way, waterway, get_waterway_grade(waterway, name, S.total_length) AS grade,
        get_waterway_grade(waterway, name, S.total_length) AS grade_total,
        waterway IN ('canal','ditch','drain') AS is_artificial, is_bridge, is_tunnel,
        get_layer(layer, is_bridge, is_tunnel) as layer, ST_Length(ST_Transform(way,900913)) AS way_length
    FROM waterway L
    LEFT JOIN stream S ON S.osm_id = L.osm_id
    WHERE
            waterway IN ('river','stream')
        AND L.osm_id > 0
        AND way && bbox

$$ LANGUAGE SQL IMMUTABLE;