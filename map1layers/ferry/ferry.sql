

CREATE OR REPLACE FUNCTION layer_ferry(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    name TEXT,
    ref TEXT,
    duration TEXT,
    operator TEXT,
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
        osm_id, way, name, ref, duration, operator, access, foot, ski, "ski:nordic", "ski:alpine", "ski:telemark",
        inline_skates,  ice_skates, horse, vehicle, bicycle, carriage, trailer, caravan, motor_vehicle, motorcycle,
        moped, mofa, motorcar, motorhome, psv, bus, atv, taxi, tourist_bus, goods, hgv, agricultural, ATV, snowmobile
    FROM ferry
    WHERE way && bbox
    ORDER BY z_order

$$ LANGUAGE SQL IMMUTABLE;





