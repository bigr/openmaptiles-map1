CREATE OR REPLACE FUNCTION get_paboundary_protect_class(
    protect_class TEXT, iuch_level TEXT, boundary TEXT, leisure TEXT, military TEXT, landuse TEXT)
RETURNS iNT AS $$
    SELECT CASE
        WHEN protect_class IS NOT NULL THEN protect_class
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('I','Ia','Ib','1','1a','1b') THEN 1
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('II','2') THEN 2
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('III','3') THEN 3
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('IV','4') THEN 4
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('V','5') THEN 5
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('VI','6') THEN 6
        WHEN iucn_level IS NOT NULL AND btrim(iucn_level) IN ('VII','7') THEN 7
        WHEN COALESCE(boundary,'') = 'national_park' THEN 2
        WHEN COALESCE(leisure,'') = 'nature_reserve' THEN 4
        WHEN COALESCE(military,'') IN ('danger_area','range') THEN 25
        WHEN COALESCE(landuse,'') = 'military' THEN 25
        ELSE 0
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_paboundary(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
        osm_id BIGINT,
        way GEOMETRY,
        protect_class INT,
		name TEXT,
		protection_title TEXT,
		protection_object TEXT,
		protection_aim TEXT,
		protection_ban TEXT,
		protection_instruction TEXT,
		related_law TEXT,
		site_zone TEXT,
		valid_from TEXT,
		start_date TEXT,
		end_date TEXT,
		opening_hours TEXT,
		operator TEXT,
		governance_type TEXT,
		site_ownership TEXT,
		site_status TEXT,
		protection_award TEXT,
		contamination TEXT,
		ethnic_group TEXT,
		period TEXT,
		scale TEXT,
		ownership TEXT,
		owner TEXT,
		attribution TEXT,
		type TEXT,
		military TEXT,
		boundary TEXT,
		landuse TEXT,
		leisure TEXT,
		wikipedia TEXT,
		website TEXT,
		way_area TEXT,
		centroid GEOMETRY

) AS $$
    SELECT
        osm_id,	way,
		get_paboundary_protect_class(protect_class, iuch_level, boundary, leisure, military, landuse) AS protect_class,
		name, protection_title, protection_object, protection_aim, protection_ban, protection_instruction,
		related_law, site_zone, valid_from, start_date, end_date, opening_hours, operator, governance_type,
        site_ownership, site_status, protection_award, contamination, ethnic_group, period, scale, ownership,
		owner, attribution, type, military, boundary, landuse, leisure, wikipedia, website, way_area,
		ST_Centroid(way) AS centroid
	FROM paboundary
	WHERE
            (
                   boundary IN ('protected_area','national_park')
                OR landuse='military'
                OR leisure='nature_reserve'
                OR military IN ('danger_area','range')
            )
        AND	way && bbox

$$ LANGUAGE SQL IMMUTABLE;