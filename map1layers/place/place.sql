

CREATE OR REPLACE FUNCTION get_place_type(place TEXT)
RETURNS TEXT $$
    SELECT CASE
        WHEN place IN ('continent','country','state','county','region','island','islat','township') THEN 'region'
        WHEN place IN ('city','town','village','hamlet','isolated_dwelling','farm') THEN 'urb'
        WHEN place IN ('suburb','neighbourhood','municipality','borough') THEN 'suburb'
        WHEN place IN ('locality') THEN 'locality'
        ELSE 'unknown'
	END
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_place_population(place TEXT, population INT)
RETURNS INT $$
    SELECT COALESCE(
	    population,
	    CASE
		    WHEN place = 'city' THEN 90000
		    WHEN place = 'town' THEN 3000
		    WHEN place IN ('suburb','borough') THEN 3000
		    WHEN place = 'village' THEN 300
		    WHEN place IN ('neighbourhood','official_neighborhood','municipality') THEN 200
		    WHEN place = 'hamlet' THEN 15
		    WHEN place IN ('isolated_dwelling','farm') THEN 3
	    END
	)
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_place_grade(place TEXT, population INT)
RETURNS INT $$
    SELECT CASE
        WHEN place = 'continent' THEN 45
        WHEN place = 'country' THEN 44
        WHEN place = 'state' THEN 43
        WHEN place = 'county' THEN 42
        WHEN place IN ('region','township') THEN 41
        ELSE floor(least(40,greatest(0,log(
                CASE
                    WHEN get_place_population(place, population) > 0
                    THEN get_place_population(place, population)
                    ELSE 1
                END)*7-7
            )))::integer
	 END
$$




CREATE OR REPLACE FUNCTION layer_place(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    place TEXT,
	type TEXT,
	grade INT,
	population INT,
	name TEXT,
	name_short TEXT,
	name_very_short TEXT,
) AS $$
    SELECT
	    osm_id, way, place, get_place_type(place) AS type, get_place_grade(place, population) AS grade,
        population, name name AS name_short, name AS name_very_short
    FROM place
    WHERE
            place IS NOT NULL
        AND name IS NOT NULL
        AND way && bbox
    ORDER BY get_place_grade(place, population) DESC

$$ LANGUAGE SQL IMMUTABLE;