DROP FUNCTION IF EXISTS generalize(geometry, float);

CREATE FUNCTION generalize(geom geometry, sz float) RETURNS geometry AS $$
    SELECT ST_Simplify(ST_Buffer(ST_Buffer(ST_Buffer(geom,sz),-2*sz), sz), sz*0.5)
$$ LANGUAGE SQL IMMUTABLE;




-- etldoc: layer_landcover[shape=record fillcolor=lightpink, style="rounded, filled", label="layer_landcover | <z0_1> z0-z1 | <z2_4> z2-z4 | <z5_6> z5-z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;

DROP FUNCTION IF EXISTS layer_landuse(geometry, int);

CREATE FUNCTION layer_landuse(bbox geometry, zoom_level int)
RETURNS TABLE(geometry geometry, class text, landuse text, amenity text, leisure text, tourism text) AS $$
    SELECT (ST_Dump(generalize(ST_Collect(geometry),zres(zoom_level)/2))).geom AS geometry,
        COALESCE(
            NULLIF(landuse, ''),
            NULLIF(amenity, ''),
            NULLIF(leisure, ''),
            NULLIF(tourism, '')
        ) AS class,
        landuse, amenity, leisure, tourism
        FROM osm_landuse_polygon
        WHERE geometry && bbox
        GROUP BY class, landuse, amenity, leisure, tourism;
$$ LANGUAGE SQL IMMUTABLE;
