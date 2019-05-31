--TODO: Find a way to nicely generalize landcover
--CREATE TABLE IF NOT EXISTS landcover_grouped_gen2 AS (
--	SELECT osm_id, ST_Simplify((ST_Dump(geometry)).geom, 600) AS geometry, landuse, "natural", wetland
--	FROM (
--	  SELECT max(osm_id) AS osm_id, ST_Union(ST_Buffer(geometry, 600)) AS geometry, landuse, "natural", wetland
--	  FROM osm_landcover_polygon_gen1
--	  GROUP BY LabelGrid(geometry, 15000000), landuse, "natural", wetland
--	) AS grouped_measurements
--);
--CREATE INDEX IF NOT EXISTS landcover_grouped_gen2_geometry_idx ON landcover_grouped_gen2 USING gist(geometry);

DROP FUNCTION IF EXISTS landcover_class(VARCHAR, VARCHAR, VARCHAR, VARCHAR);

CREATE FUNCTION landcover_class(landuse VARCHAR, "natural" VARCHAR, leisure VARCHAR, wetland VARCHAR) RETURNS TEXT AS $$
    SELECT CASE
        WHEN landuse IN ('farmland', 'farm', 'orchard', 'vineyard', 'plant_nursery') THEN 'farmland'
        WHEN "natural" IN ('glacier', 'ice_shelf') THEN 'ice'
        WHEN "natural"='wood' OR landuse IN ('forest') THEN 'wood'
        WHEN "natural" IN ('bare_rock', 'scree') THEN 'rock'
        WHEN "natural"='grassland'
            OR landuse IN ('grass', 'meadow', 'allotments', 'grassland',
                'park', 'village_green', 'recreation_ground')
            OR leisure IN ('park', 'garden')
            THEN 'grass'
        WHEN "natural"='wetland' OR wetland IN ('bog', 'swamp', 'wet_meadow', 'marsh', 'reedbed', 'saltern', 'tidalflat', 'saltmarsh', 'mangrove') THEN 'wetland'
        WHEN "natural"IN ('beach', 'sand') THEN 'sand'
        ELSE NULL
    END;
$$ LANGUAGE SQL IMMUTABLE;

DROP FUNCTION IF EXISTS generalize(geometry, float);

CREATE FUNCTION generalize(geom geometry, sz float) RETURNS geometry AS $$
    SELECT ST_Simplify(ST_Buffer(ST_Buffer(ST_Buffer(geom,sz),-2*sz), sz), sz*0.5)
$$ LANGUAGE SQL IMMUTABLE;




-- etldoc: layer_landcover[shape=record fillcolor=lightpink, style="rounded, filled", label="layer_landcover | <z0_1> z0-z1 | <z2_4> z2-z4 | <z5_6> z5-z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

DROP FUNCTION IF EXISTS layer_landcover(geometry, int);

CREATE FUNCTION layer_landcover(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, subclass text, landuse text, "natural" text, leisure text, wetland text) AS $$
    SELECT (ST_Dump(generalize(ST_Collect(geometry),zres(zoom_level)))).geom AS geometry,
        landcover_class(landuse, "natural", leisure, wetland) AS class,
        COALESCE(
            NULLIF("natural", ''), NULLIF(landuse, ''),
            NULLIF(leisure, ''), NULLIF(wetland, '')
        ) AS subclass,
        landuse, "natural", leisure, wetland
        FROM osm_landcover_polygon
        --WHERE geometry && bbox
        GROUP BY class, subclass, landuse, "natural", leisure, wetland;
$$ LANGUAGE SQL IMMUTABLE;
