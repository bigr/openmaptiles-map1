
CREATE OR REPLACE FUNCTION layer_landcover_point(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    natural TEXT,
    wood TEXT,
    name TEXT,
    species TEXT,
    genus TEXT,
    taxon TEXT,
    denotation TEXT,
    attribution TEXT,
    wikipedia TEXT,
    website TEXT
) AS $$
    SELECT
		osm_id, way, natural, wood, name, species, genus, taxon, denotation, attribution, wikipedia, website
    WHERE way && bbox
$$ LANGUAGE SQL IMMUTABLE;