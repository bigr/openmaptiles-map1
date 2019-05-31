DROP FUNCTION IF EXISTS water_class(text);

CREATE FUNCTION water_class(waterway TEXT) RETURNS TEXT AS $$
    SELECT CASE
           WHEN waterway='' THEN 'lake'
           WHEN waterway='dock' THEN 'dock'
           ELSE 'river'
   END;
$$ LANGUAGE SQL IMMUTABLE;

DROP FUNCTION IF EXISTS generalize(geometry, float);

CREATE FUNCTION generalize(geom geometry, sz float) RETURNS geometry AS $$
    SELECT ST_Simplify(ST_Buffer(ST_Buffer(ST_Buffer(geom,sz),-2*sz), sz), sz*0.5)
$$ LANGUAGE SQL IMMUTABLE;


DROP FUNCTION IF EXISTS layer_water(geometry, int);

CREATE FUNCTION layer_water(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, waterway text) AS $$
    SELECT (ST_Dump(generalize(ST_Collect(geometry),zres(zoom_level)/2))).geom AS geometry,
        water_class(waterway) AS class,
        waterway
        FROM osm_water_polygon
        WHERE geometry && bbox
        GROUP BY class, waterway;
$$ LANGUAGE SQL IMMUTABLE;
