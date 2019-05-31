
CREATE OR REPLACE FUNCTION get_smoothness(smoothness INT, highway TEXT, tracktype TEXT, surface TEXT)
RETURNS INT AS $$
    SELECT CASE
        WHEN smoothness NOT NULL THEN smoothness
	    WHEN highway IN ('motorway','trunk','motorway_link','trunk_link') THEN 0
	    WHEN highway IN (
	        'primary','primary_link','secondary','secondary_link','tertiary','tertiary_link','unclassified',
	        'minor','service','residential','living_street','pedestrian') THEN (
	            CASE
		            WHEN surface IN ('unpaved','compacted','fine_gravel','grass_paver') THEN 2
		            WHEN surface IN ('dirt','earth','ground','gravel','mud','sand','grass') THEN 3
		            ELSE 1
	            END
	        )
	    WHEN highway = 'track' THEN (
	        CASE
		        WHEN tracktype = 'grade1' THEN (
		            CASE
			            WHEN surface IN (
			                'asphalt','cobblestone:flattened','concrete:plates','paving_stones',
			                'paving_stones:30','paving_stones:20') THEN 1
			            WHEN surface IN ('unpaved','compacted','fine_gravel','grass_paver','gravel') THEN 3
			            WHEN surface IN ('dirt','earth','ground','mud','sand','grass') THEN 4
			            ELSE 2
		            END
		        )
		        WHEN tracktype IN ('grade2','grade3') THEN (
		            CASE
			            WHEN surface IN (
			                'asphalt','cobblestone:flattened','concrete:plates','paving_stones','paving_stones:30',
			                'paving_stones:20','paved','cobblestone','concrete ','concrete:lanes','paving_stones:30',
			                'paving_stones:20','wood','metal') THEN 2
			            WHEN surface IN ('dirt','earth','ground','mud','sand','grass') THEN 4
			            ELSE 3
		            END
		        )
		        ELSE (
		            CASE
			            WHEN surface IN (
			                'paved','asphalt','cobblestone:flattened','concrete:plates','paving_stones',
			                'paving_stones:30','paving_stones:20','paved','cobblestone','concrete ','concrete:lanes',
			                'paving_stones:30','paving_stones:20','wood','metal') THEN 3
			            WHEN surface IN ('sand','grass') THEN 5
			            ELSE 4
		            END
		        )
	        END
	    )
	    WHEN highway = 'road' THEN  (
	        CASE
		        WHEN surface IN (
		            'paved','asphalt','cobblestone:flattened','concrete:plates','paving_stones','paving_stones:30',
		            'paving_stones:20','paved','cobblestone','concrete ','concrete:lanes','paving_stones:30',
		            'paving_stones:20','wood','metal') THEN 3
		        WHEN surface IN ('sand','grass') THEN 5
		        ELSE 4
	        END
	    )
	    WHEN highway IN ('cycleway','footway') THEN  (
	        CASE
		        WHEN surface IN ('unpaved','compacted','fine_gravel','grass_paver','gravel') THEN 3
		        WHEN surface IN ('dirt','earth','ground','mud','sand','grass') THEN 4
		        ELSE 1
	        END
	    )
	    WHEN highway = 'bridleway' THEN  (
	        CASE
		        WHEN surface IN (
		            'paved','asphalt','cobblestone:flattened','concrete:plates','paving_stones','paving_stones:30',
		            'paving_stones:20','paved','cobblestone','concrete ','concrete:lanes','paving_stones:30',
		            'paving_stones:20','wood','metal') THEN 2
		        ELSE 4
	        END
	    )
	    WHEN highway = 'steps' THEN 7
	    ELSE (
	        CASE
		        WHEN surface IN (
		            'paved','asphalt','cobblestone:flattened','concrete:plates','paving_stones','paving_stones:30',
		            'paving_stones:20','paved','cobblestone','concrete ','concrete:lanes','paving_stones:30',
		            'paving_stones:20','wood','metal') THEN 3
		        WHEN surface IN ('sand','grass') THEN 5
		        ELSE 4
	        END
	    )
	END
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_highway_type(highway TEXT, tracktype TEXT, surface TEXT, smoothness INT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN highway = 'footway' AND get_smoothness(smoothness, highway, tracktype, surface) > 2 THEN 'path'
        WHEN highway IN (
            'footway','cycleway','bridleway','motorway','motorway_link','trunk','trunk_link',
            'primary','primary_link','secondary','secondary_link','tertiary','tertiary_link',
            'unclassified','minor','service','residential','living_street','pedestrian','track') THEN 'road'
        WHEN highway IN ('path','steps') THEN 'path'
        ELSE 'unknown'
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION get_highway_grade(highway TEXT, tracktype TEXT)
RETURNS INT AS $$
    SELECT CASE
        WHEN highway IN ('motorway','motorway_link') THEN 0
        WHEN highway IN ('trunk','trunk_link') THEN 1
        WHEN highway IN ('primary','primary_link') THEN 2
        WHEN highway IN ('secondary','secondary_link') THEN 3
        WHEN highway IN ('tertiary','tertiary_link') THEN 4
        WHEN highway IN ('unclassified','minor') THEN 5
        WHEN highway IN ('service') THEN 6
        WHEN highway IN ('residential','living_street','pedestrian') THEN 7
        WHEN highway = 'track' THEN (
            CASE
                WHEN tracktype = 'grade1' THEN 8
                WHEN tracktype = 'grade2' THEN 9
                WHEN tracktype = 'grade3' THEN 10
                WHEN tracktype = 'grade4' THEN 11
                WHEN tracktype = 'grade5' THEN 12
                ELSE 13
            END
        )
        WHEN highway = 'road' THEN 13
        WHEN highway IN ('footway','cycleway') THEN 8 
        WHEN highway IN ('bridleway','steps') THEN 9 
        WHEN highway = 'path' THEN 12
        ELSE 13
    END
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_highway(highway TEXT, construction TEXT, proposed TEXT)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN highway = 'construction' THEN construction
        WHEN highway = 'proposed' THEN proposed
        ELSE highway
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION get_is_construction(highway TEXT, construction TEXT)
RETURNS BOOLEAN AS $$
    SELECT CASE
        WHEN highway = 'construction' THEN TRUE
        WHEN construction IN ('yes', '1','true') THEN TRUE
        ELSE FALSE
    END
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_is_proposed(highway TEXT, proposed TEXT)
RETURNS BOOLEAN AS $$
    SELECT CASE
        WHEN highway = 'proposed' THEN TRUE
        WHEN proposed IN ('yes', '1','true') THEN TRUE
        ELSE FALSE
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_highway(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    highway TEXT,
    layer INT,
    type TEXT,
    footway TEXT,
    cycleway TEXT,
    service TEXT,
    tracktype TEXT,
    bridge TEXT,
    tunnel TEXT,
    grade INT,
    smoothness INT,
    surface TEXT,
    "mtb:scale" TEXT,
    sac_scale TEXT,
    attribution TEXT,
    lanes TEXT,
    lit TEXT,
    sidewalk TEXT,
    width TEXT,
    maxspeed TEXT,
    is_link BOOLEAN,
    is_bridge BOOLEAN,
    is_tunnel BOOLEAN,
    junction TEXT,
    is_construction BOOLEAN,
    is_proposed BOOLEAN
    ref TEXT,
    int_ref TEXT,
    ref_length INT,
    intref_length INT,
    oneway INT,
    has_name BOOLEAN,
    name TEXT,
    way_length REAL,
    access TEXT,
    foot TEXT,
    ski TEXT,
    "ski:nordic" TEXT,
    "ski:alpine" TEXT,
    "ski:telemark" TEXT,
    inline_skates TEXT,
    ice_skates TEXT,
    horse TEXT,
    vehicle TEXT,
    bicycle TEXT,
    carriage TEXT,
    trailer TEXT,
    caravan TEXT,
    motor_vehicle TEXT,
    motorcycle TEXT,
    moped TEXT,
    mofa TEXT,
    motorcar TEXT,
    motorhome TEXT,
    psv TEXT,
    bus TEXT,
    atv TEXT,
    taxi TEXT,
    tourist_bu TEXT,s
    goods TEXT,
    hgv TEXT,
    agricultural TEXT,
    ATV TEXT,
    snowmobile TEXT
) AS $$
    SELECT
        osm_id, way, get_highway(highway, constructino, proposed) as highway, get_layer(layer, is_bridge, is_tunnel),
		get_highway_type(get_highway(highway, construction, proposed), tracktype, surface, smoothness) AS type,
	    footway, cycleway, service, tracktype, bridge, tunnel,
        get_highway_grade(get_highway(highway, construction, proposed), tracktype) AS grade,
        get_smoothness(smoothness::INT, highway, tracktype, surface) AS smoothness,
	    surface, "mtb:scale", sac_scale, attribution, lanes, lit, sidewalk, width, maxspeed,
	    get_highway(highway, construction, proposed) in
	        ('motorway_link','trunk_link','primary_link','secondary_link','tertiary_link') AS is_link,
	    is_bridge, is_tunnel, COALESCE(junction,CAST('no' AS text)) AS junction,
		get_is_construction(highway, construction) AS is_construction,
		get_is_proposed(highway, proposed) AS is_proposed,
	    ref, int_ref, LENGTH(ref) AS ref_length, LENGTH(int_ref) AS intref_length, oneway,
		(name IS NOT NULL AND name <> '') AS has_name, name, ST_Length(ST_Transform(way,900913)) AS way_length,
	    access,foot,ski,"ski:nordic","ski:alpine","ski:telemark",ice_skates,inline_skates,horse,
	    vehicle,bicycle,carriage,trailer,caravan,motor_vehicle,motorcycle,moped,mofa,motorcar,motorhome,
	    psv,bus,taxi,tourist_bus,goods,hgv,agricultural,ATV,snowmobile
	FROM highway
    WHERE way && bbox

$$ LANGUAGE SQL IMMUTABLE;