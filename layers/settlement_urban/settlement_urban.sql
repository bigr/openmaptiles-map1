

CREATE OR REPLACE FUNCTION layer_settlement_urban(bbox geometry, zoom_level int, pixel_width numeric)
RETURNS TABLE(osm_id bigint, geometry geometry, name text, class text) AS $$
    SELECT osm_id, geometry, name, place as class
    FROM osm_settlement_urban_point
    WHERE geometry && bbox AND (
          place == 'city' OR
          place == 'town' AND zoom_level >= 9 OR
          place == 'village' AND zoom_level >= 11 OR
          zoom_level >= 13
      );
$$ LANGUAGE SQL IMMUTABLE;
