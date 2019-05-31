

CREATE OR REPLACE FUNCTION layer_peaks(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    grade REAL,
    name TEXT,
    ele INT
) AS $$
    SELECT
        osm_id
		way,
		get_peaks_grade(way, ele) AS grade
		name,
		ele
	FROM peaks
	WHERE
            "natural" = 'peak'
        AND (name IS NOT NULL OR ele IS NOT NULL)
        AND way && bbox
	ORDER BY ele DESC

$$ LANGUAGE SQL IMMUTABLE;