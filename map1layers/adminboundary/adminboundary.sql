
CREATE OR REPLACE FUNCTION layer_adminboundary(bbox geometry, zoom_level int)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        access TEXT,
        way_area REAL,
        centroid GEOMETRY
) AS $$
    SELECT
        osm_id, way, COALESCE(access, CAST('null' AS text)) AS access, name, way_area, ST_Centroid(way) AS centroid
    FROM accessarea
    WHERE way && bbox
    ORDER BY way_area DESC
$$ LANGUAGE SQL IMMUTABLE;