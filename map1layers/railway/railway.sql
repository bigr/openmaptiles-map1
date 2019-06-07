

CREATE OR REPLACE FUNCTION get_railway(railway VARCHAR, construction VARCHAR, proposed VARCHAR)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN railway = 'construction' THEN construction
        WHEN railway = 'proposed' THEN proposed
        ELSE railway
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION get_railway_grade(railway VARCHAR, usage VARCHAR, service VARCHAR)
RETURNS INT AS $$
    SELECT CASE
        WHEN railway IN ('rail','narrow_gaugue') THEN (
            CASE
                WHEN usage IN ('main','mainline','highspeed') THEN 1
                WHEN usage IN ('industrial','military','tourism','Stock','yard','siding','garage','preserved') THEN 4
                WHEN service IN ('siding','spur','yeard') THEN 4
                ELSE 2
            END
        )
        WHEN railway IN ('preserved','preserved_rail') THEN 4
        WHEN railway = 'light_rail' THEN 3
        WHEN railway = 'disused' THEN 5
    END
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_railway_type(railway VARCHAR)
RETURNS TEXT AS $$
    SELECT CASE
        WHEN railway IN ('rail','light_rail','disused','abandoned','narrow_gauge') THEN 'train'
        WHEN railway IN ('tram', 'subway', 'funicular', 'monorail', 'platform', 'abandoned') THEN railway
        ELSE 'unknown'
    END
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_railway(bbox GEOMETRY, zoom_level INT, pixel_width NUMERIC)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    railway VARCHAR,
    type VARCHAR,
    grade INT,
    name VARCHAR,
    layer INT,
    is_bridge BOOLEAN,
    is_tunnel BOOLEAN,
    is_construction BOOLEAN,
    is_proposed BOOLEAN,
    usage VARCHAR,
    service VARCHAR,
    gauge INT,
    cutting VARCHAR,
    embankment VARCHAR,
    electrified VARCHAR,
    frequency VARCHAR,
    voltage VARCHAR,
    operator VARCHAR,
    maxspeed VARCHAR,
    wikipedia VARCHAR,
    website VARCHAR,
    colour VARCHAR,
    transport VARCHAR,
    public_transport VARCHAR,
    tram VARCHAR,
    surface VARCHAR,
    width INT,
    way_length DOUBLE PRECISION
) AS $$
    SELECT
        osm_id, way, get_railway(railway, construction, proposed) as railway, get_railway_type(get_railway(railway, construction, proposed)) AS type,
        get_railway_grade(get_railway(railway, construction, proposed), usage, service) AS grade, name,
        get_layer(layer, is_bridge, is_tunnel) as layer, is_bridge, is_tunnel,
        get_is_construction(railway, construction) AS is_construction, get_is_proposed(railway, proposed) AS is_proposed,
        usage, service, gauge, cutting, embankment, electrified, frequency, voltage, operator, maxspeed,
        wikipedia, website, colour, transport, public_transport, tram, surface, width,
        ST_Length(ST_Transform(way,900913)) AS way_length
    FROM osm_railway
    WHERE
             railway IS NOT NULL
        AND way && bbox
	ORDER BY get_railway_grade(get_railway(railway, construction, proposed), usage, service), osm_id DESC

$$ LANGUAGE SQL IMMUTABLE;