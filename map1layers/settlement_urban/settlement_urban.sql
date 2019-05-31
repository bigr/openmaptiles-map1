
DROP FUNCTION IF EXISTS layer_settlement_urban(geometry, int, numeric);

CREATE FUNCTION layer_settlement_urban(bbox geometry, zoom_level int, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, class text, population int, capital text) AS $$
    SELECT osm_id, geometry, name, class, population, capital
    FROM osm_settlement_urban_point
    WHERE geometry && bbox AND (
          class = 'city' OR
          class = 'town' AND zoom_level >= 7 OR
          class = 'village' AND zoom_level >= 8 OR
          class = 'hamlet' AND zoom_level >= 9 OR
          class = 'isolated_dwelling' AND zoom_level >= 10
      );
$$ LANGUAGE SQL IMMUTABLE;
