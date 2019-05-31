CREATE OR REPLACE FUNCTION get_layer(layer REAL, is_bridge BOOLEAN, is_tunnel BOOLEAN)
RETURNS INT AS $$
    SELECT CASE
        WHEN layer IN ('-5','-4','-3','-2','-1','0','1','2','3','4','5') THEN CAST(round(CAST(layer AS REAL)) AS INT)
        WHEN is_bridge THEN 1
        WHEN is_tunnel THEN -1
        ELSE 0
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_aerialway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        aerialway TEXT,
        "piste:lift" TEXT,
        layer INT,
        name TEXT
) AS $$
    SELECT
        osm_id, way, aerialway, COALESCE("piste:lift",'no') AS "piste:lift",
        get_layer(layer, is_bridge, is_tunnel) as layer, name
    FROM aerialway
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;