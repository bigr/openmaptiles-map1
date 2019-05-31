
CREATE OR REPLACE FUNCTION get_symbol_type(historic, castle_type, ruins, building, amenity, railway, tourism, highway, shop, sport, place_of_worship)
RETURNS INT AS $$
SELECT (
    CASE
         WHEN ((((COALESCE("historic",'') = 'castle') AND ( "castle_type" IS NULL OR "castle_type" = 'no' ) AND ( "ruins" IS NULL OR "ruins" = 'no' )) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'stately') AND ( "ruins" IS NULL OR "ruins" = 'no' )) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'schloss') AND ( "ruins" IS NULL OR "ruins" = 'no' )) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'burg;schloss') AND ( "ruins" IS NULL OR "ruins" = 'no' )))) THEN 1
         WHEN ((((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'defensive')) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'burg')) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'fortress')) OR ((COALESCE("historic",'') = 'castle') AND (COALESCE("castle_type",'') = 'festung')))) THEN 2
         WHEN (((( "ruins" IS NOT NULL AND "ruins" <> 'no' ) AND (COALESCE("historic",'') = 'castle')) OR ((COALESCE("ruins",'') = 'castle')))) THEN 3
         WHEN ((((COALESCE("building",'') = 'church')) OR ((COALESCE("amenity",'') = 'place_of_worship') AND (COALESCE("historic",'') <> 'monastery') AND (COALESCE("historic",'') <> 'wayside_shrine') AND (COALESCE("historic",'') <> 'wayside_cross') AND (COALESCE("building",'') <> 'chapel') AND (COALESCE("place_of_worship:type",'') <> 'chapel') AND (COALESCE("place_of_worship",'') <> 'chapel') AND (COALESCE("place_of_worship:type",'') <> 'monastery') AND (COALESCE("place_of_worship",'') <> 'monastery')))) THEN 4
         WHEN ((((COALESCE("building",'') = 'chapel')) OR ((COALESCE("place_of_worship:type",'') = 'chapel')) OR ((COALESCE("place_of_worship",'') = 'chapel')))) THEN 5
         WHEN ((((COALESCE("military",'') = 'bunker') AND (COALESCE("historic",'') = 'yes')))) THEN 6
         WHEN ((((COALESCE("historic",'') = 'monastery')) OR ((COALESCE("place_of_worship:type",'') = 'monastery')) OR ((COALESCE("place_of_worship",'') = 'monastery')))) THEN 7
         WHEN ((((COALESCE("historic",'') = 'archaeological_site')))) THEN 8
         WHEN ((((COALESCE("historic",'') = 'city_gate')))) THEN 9
         WHEN ((((COALESCE("historic",'') = 'monument')))) THEN 10
         WHEN ((((COALESCE("historic",'') = 'memorial')) OR ((COALESCE("historic",'') = 'heritage')))) THEN 11
         WHEN ((((COALESCE("historic",'') = 'wayside_cross')) OR ((COALESCE("amenity",'') = 'place_of_worship') AND ( "historic" IS NULL OR "historic" = 'no' ) AND ( "building" IS NULL OR "building" = 'no' )))) THEN 12
         WHEN ((((COALESCE("historic",'') = 'wayside_shrine')))) THEN 13
         WHEN ((((COALESCE("historic",'') = 'boundary_stone')))) THEN 14
         WHEN ((((COALESCE("historic",'') = 'battlefield')))) THEN 15
         WHEN ((((COALESCE("man_made",'') = 'tower') AND (COALESCE("tower:type",'') = 'observation')) OR ((COALESCE("man_made",'') = 'tower') AND (COALESCE("tourism",'') = 'attraction')))) THEN 16
         WHEN ((((COALESCE("man_made",'') = 'lighthouse')))) THEN 17
         WHEN ((((COALESCE("man_made",'') = 'tower') AND (COALESCE("tower:type",'') = 'communication')))) THEN 18
         WHEN ((((COALESCE("man_made",'') = 'water_tower')))) THEN 19
         WHEN ((((COALESCE("tourism",'') = 'viewpoint')))) THEN 20
         WHEN ((((COALESCE("tourism",'') = 'museum')))) THEN 21
         WHEN ((((COALESCE("tourism",'') = 'zoo')))) THEN 22
         WHEN ((((COALESCE("tourism",'') = 'camp_site')))) THEN 23
         WHEN ((((COALESCE("tourism",'') = 'information') AND (COALESCE("information",'') = 'guidepost')))) THEN 24
         WHEN ((((COALESCE("tourism",'') = 'information') AND (COALESCE("information",'') = 'board')))) THEN 25
         WHEN ((((COALESCE("tourism",'') = 'information') AND (COALESCE("information",'') = 'map')))) THEN 26
         WHEN ((((COALESCE("tourism",'') = 'information') AND (COALESCE("information",'') = 'office')))) THEN 27
         WHEN ((((COALESCE("tourism",'') = 'artwork')))) THEN 28
         WHEN ((((COALESCE("amenity",'') = 'atm')))) THEN 29
         WHEN ((((COALESCE("amenity",'') = 'bank')))) THEN 30
         WHEN ((((COALESCE("amenity",'') = 'bench')))) THEN 31
         WHEN ((((COALESCE("natural",'') = 'cave_entrance')))) THEN 32
         WHEN ((((COALESCE("amenity",'') = 'doctors')) OR ((COALESCE("amenity",'') = 'dentist')))) THEN 33
         WHEN ((((COALESCE("amenity",'') = 'hospital')))) THEN 34
         WHEN ((((COALESCE("amenity",'') = 'clinic')) OR ((COALESCE("amenity",'') = 'nursing_home')))) THEN 35
         WHEN ((((COALESCE("amenity",'') = 'drinking_water')))) THEN 36
         WHEN ((((COALESCE("amenity",'') = 'fuel')))) THEN 37
         WHEN ((((COALESCE("tourism",'') = 'guest_house')) OR ((COALESCE("tourism",'') = 'hostel')) OR ((COALESCE("tourism",'') = 'motel')) OR ((COALESCE("tourism",'') = 'hut')) OR ((COALESCE("tourism",'') = 'alpine_hut')))) THEN 38
         WHEN ((((COALESCE("tourism",'') = 'hotel')))) THEN 39
         WHEN ((((COALESCE("man_made",'') = 'hunting_stand')) OR ((COALESCE("amenity",'') = 'hunting_stand')))) THEN 40
         WHEN ((((COALESCE("amenity",'') = 'parking')))) THEN 41
         WHEN ((((COALESCE("amenity",'') = 'parking_entrance')))) THEN 42
         WHEN ((((COALESCE("amenity",'') = 'pharmacy')))) THEN 43
         WHEN ((((COALESCE("tourism",'') = 'picnic_site')) OR ((COALESCE("leisure",'') = 'picnic_table')))) THEN 44
         WHEN ((((COALESCE("amenity",'') = 'post_box')))) THEN 45
         WHEN ((((COALESCE("amenity",'') = 'post_office')))) THEN 46
         WHEN ((((COALESCE("amenity",'') = 'pub')) OR ((COALESCE("amenity",'') = 'bar')) OR ((COALESCE("amenity",'') = 'nightclub')))) THEN 47
         WHEN ((((COALESCE("amenity",'') = 'cafe')))) THEN 48
         WHEN ((((COALESCE("amenity",'') = 'restaurant')) OR ((COALESCE("amenity",'') = 'fast_food')) OR ((COALESCE("amenity",'') = 'biergarten')))) THEN 49
         WHEN ((((COALESCE("amenity",'') = 'shelter')))) THEN 50
         WHEN ((((COALESCE("natural",'') = 'spring')))) THEN 51
         WHEN ((((COALESCE("amenity",'') = 'theatre')))) THEN 52
         WHEN ((((COALESCE("man_made",'') = 'watermill')))) THEN 53
         WHEN ((((COALESCE("man_made",'') = 'water_well')))) THEN 54
         WHEN ((((COALESCE("man_made",'') = 'windmill')))) THEN 55
         WHEN ((((COALESCE("amenity",'') = 'fountain')))) THEN 56
         WHEN ((((COALESCE("railway",'') = 'tram_stop')))) THEN 57
         WHEN ((((COALESCE("highway",'') = 'bus_stop')))) THEN 58
         WHEN ((((COALESCE("aeroway",'') = 'aerodrome')))) THEN 59
         WHEN ((((COALESCE("railway",'') = 'subway_entrance')))) THEN 60
         WHEN ((((COALESCE("railway",'') = 'halt')))) THEN 61
         WHEN ((((COALESCE("amenity",'') = 'ferry_terminal')))) THEN 62
         WHEN ((((COALESCE("railway",'') = 'station') AND (COALESCE("transport",'') <> 'subway')))) THEN 63
         WHEN ((((COALESCE("railway",'') = 'station') AND (COALESCE("transport",'') = 'subway')))) THEN 64
         WHEN ((((COALESCE("amenity",'') = 'car_rental')))) THEN 65
         WHEN ((((COALESCE("amenity",'') = 'car_sharing')))) THEN 66
         WHEN ((((COALESCE("amenity",'') = 'school')))) THEN 67
         WHEN ((((COALESCE("amenity",'') = 'kindergarten')))) THEN 68
         WHEN ((((COALESCE("amenity",'') = 'recycling')) OR ((COALESCE("amenity",'') = 'waste_basket')))) THEN 69
         WHEN ((((COALESCE("amenity",'') = 'clock')))) THEN 70
         WHEN ((((COALESCE("amenity",'') = 'icecream')))) THEN 71
         WHEN ((((COALESCE("amenity",'') = 'bicycle_parking')))) THEN 72
         WHEN ((((COALESCE("amenity",'') = 'motorcycle_parking')))) THEN 73
         WHEN ((((COALESCE("amenity",'') = 'telephone')))) THEN 74
         WHEN ((((COALESCE("amenity",'') = 'fire_hydrant')))) THEN 75
         WHEN ((((COALESCE("amenity",'') = 'toilets')))) THEN 76
         WHEN ((((COALESCE("amenity",'') = 'shower')))) THEN 77
         WHEN ((((COALESCE("amenity",'') = 'taxi')))) THEN 78
         WHEN ((((COALESCE("amenity",'') = 'car_wash')))) THEN 79
         WHEN ((((COALESCE("amenity",'') = 'public_building')) OR ((COALESCE("amenity",'') = 'comunity_centre')))) THEN 80
         WHEN ((((COALESCE("amenity",'') = 'fire_station')))) THEN 81
         WHEN ((((COALESCE("amenity",'') = 'police')))) THEN 82
         WHEN ((((COALESCE("amenity",'') = 'swimming_pool')))) THEN 83
         WHEN ((((COALESCE("amenity",'') = 'townhall')))) THEN 84
         WHEN ((((COALESCE("amenity",'') = 'library')))) THEN 85
         WHEN ((((COALESCE("amenity",'') = 'university')) OR ((COALESCE("amenity",'') = 'college')))) THEN 86
         WHEN ((((COALESCE("amenity",'') = 'social_facility')))) THEN 87
         WHEN ((((COALESCE("amenity",'') = 'marketplace')))) THEN 88
         WHEN ((((COALESCE("amenity",'') = 'cinema')))) THEN 89
         WHEN ((((COALESCE("amenity",'') = 'veterinary')))) THEN 90
         WHEN ((((COALESCE("amenity",'') = 'courthouse')))) THEN 91
         WHEN ((((COALESCE("amenity",'') = 'prison')))) THEN 92
         WHEN ((((COALESCE("amenity",'') = 'arts_centre')))) THEN 93
         WHEN ((((COALESCE("amenity",'') = 'embassy')))) THEN 94
         WHEN ((((COALESCE("amenity",'') = 'driving_school')))) THEN 95
         WHEN ((((COALESCE("amenity",'') = 'studio')))) THEN 96
         WHEN ((((COALESCE("amenity",'') = 'brothel')))) THEN 97
         WHEN ((((COALESCE("amenity",'') = 'sauna')))) THEN 98
         WHEN ((((COALESCE("amenity",'') = 'retirement_home')))) THEN 99
         WHEN ((((COALESCE("shop",'') = 'supermarket')))) THEN 100
         WHEN ((((COALESCE("shop",'') = 'convenience')))) THEN 101
         WHEN ((((COALESCE("shop",'') = 'clothes')))) THEN 102
         WHEN ((((COALESCE("shop",'') = 'bakery')))) THEN 103
         WHEN ((((COALESCE("shop",'') = 'hairdresser')))) THEN 104
         WHEN ((((COALESCE("shop",'') = 'car_repair')))) THEN 105
         WHEN ((((COALESCE("shop",'') = 'car')))) THEN 106
         WHEN ((((COALESCE("shop",'') = 'kiosk')))) THEN 107
         WHEN ((((COALESCE("shop",'') = 'butcher')))) THEN 108
         WHEN ((((COALESCE("shop",'') = 'florist')))) THEN 109
         WHEN ((((COALESCE("shop",'') = 'alcohol')))) THEN 110
         WHEN ((((COALESCE("shop",'') = 'mall')))) THEN 111
         WHEN ((((COALESCE("shop",'') = 'bicycle')))) THEN 112
         WHEN ((((COALESCE("shop",'') = 'furniture')))) THEN 113
         WHEN ((((COALESCE("shop",'') = 'books')))) THEN 114
         WHEN ((((COALESCE("shop",'') = 'electronics')))) THEN 115
         WHEN ((((COALESCE("shop",'') = 'shoes')))) THEN 116
         WHEN ((((COALESCE("shop",'') = 'department_store')))) THEN 117
         WHEN ((((COALESCE("shop",'') = 'hardware')))) THEN 118
         WHEN ((((COALESCE("shop",'') = 'optician')))) THEN 119
         WHEN ((((COALESCE("shop",'') = 'jewelry')))) THEN 120
         WHEN ((((COALESCE("shop",'') = 'chemist')))) THEN 121
         WHEN ((((COALESCE("shop",'') = 'gift')))) THEN 122
         WHEN ((((COALESCE("shop",'') = 'garden_centre')))) THEN 123
         WHEN ((((COALESCE("shop",'') = 'greengrocer')))) THEN 124
         WHEN ((((COALESCE("shop",'') = 'mobile_phone')))) THEN 125
         WHEN ((((COALESCE("shop",'') = 'beverages')))) THEN 126
         WHEN ((((COALESCE("shop",'') = 'computer')))) THEN 127
         WHEN ((((COALESCE("shop",'') = 'sports')))) THEN 128
         WHEN ((((COALESCE("shop",'') = 'laundry')))) THEN 129
         WHEN ((((COALESCE("shop",'') = 'toys')))) THEN 130
         WHEN ((((COALESCE("shop",'') = 'confectionery')))) THEN 131
         WHEN ((((COALESCE("shop",'') = 'travel_agency')))) THEN 132
         WHEN ((((COALESCE("shop",'') = 'stationery')))) THEN 133
         WHEN ((((COALESCE("shop",'') = 'hifi')))) THEN 134
         WHEN ((((COALESCE("shop",'') = 'dry_cleaning')))) THEN 135
         WHEN ((((COALESCE("shop",'') = 'variety_store')))) THEN 136
         WHEN ((((COALESCE("sport",'') = 'soccer')) OR ((COALESCE("sport",'') = 'football')))) THEN 137
         WHEN ((((COALESCE("sport",'') = 'tennis')))) THEN 138
         WHEN ((((COALESCE("sport",'') = 'baseball')))) THEN 139
         WHEN ((((COALESCE("sport",'') = 'swimming')))) THEN 140
         WHEN ((((COALESCE("sport",'') = 'hillclimbing')))) THEN 141
         WHEN ((((COALESCE("sport",'') = 'multi')))) THEN 142
         WHEN ((((COALESCE("sport",'') = 'basketball')))) THEN 143
         WHEN ((((COALESCE("sport",'') = 'golf')))) THEN 144
         WHEN ((((COALESCE("sport",'') = 'athletics')))) THEN 145
         WHEN ((((COALESCE("sport",'') = 'equestrian')))) THEN 146
         WHEN ((((COALESCE("sport",'') = 'bowls')))) THEN 147
         WHEN ((((COALESCE("sport",'') = 'skiing')))) THEN 148
         WHEN ((((COALESCE("sport",'') = 'volleyball')))) THEN 149
         WHEN ((((COALESCE("sport",'') = 'shooting')))) THEN 150
         WHEN ((((COALESCE("sport",'') = 'skateboard')))) THEN 151
         WHEN ((((COALESCE("sport",'') = 'cricket')))) THEN 152
         WHEN ((((COALESCE("sport",'') = 'beachvolleyball')))) THEN 153
         WHEN ((((COALESCE("sport",'') = 'table_tennis')))) THEN 154
         WHEN ((((COALESCE("sport",'') = 'gymnastics')))) THEN 155
         WHEN ((((COALESCE("sport",'') = 'boules')))) THEN 156
     END)
$$ LANGUAGE SQL IMMUTABLE;

CREATE OR REPLACE FUNCTION get_symbol_grade(
    historic, castle_type, ruins, building, amenity, railway, tourism, highway, shop, sport, place_of_worship)
RETURNS REAL AS $$
    SELECT (
        CASE
            WHEN historic='castle' AND (castle_type IN ('defensive','burg','fortress')) AND ruins = 'no' THEN 2.5
		    WHEN historic='castle' AND (
		        castle_type IN ('stately','schloss','burg;schloss') OR castle_type IS NULL) AND ruins = 'no' THEN 2.0
		    WHEN historic='castle' AND (castle_type IN ('defensive','burg','fortress')) THEN 1.8
		    WHEN historic='ruins' OR ruins='yes' THEN 1.3
		    WHEN building='church' OR (amenity='place_of_worship' AND
		        COALESCE(place_of_worship,place_of_worship_type,building,historic,'church') NOT IN
		            ('chapel','monastery','wayside_shrine','wayside_cross')) THEN 1.0
		    WHEN COALESCE(place_of_worship_type,place_of_worship,historic)='monastery' THEN 2.0
		    WHEN amenity = 'theatre' THEN 0.5
		    WHEN tourism = 'museum' THEN 0.8
		    WHEN tourism IN ('hotel','hostel','motel','guest_house','alpine_hut','hut') THEN 0.15
		    WHEN amenity = 'restaurant' THEN 0.1
		    WHEN amenity = 'cinema' THEN 0.07
		    WHEN amenity IN ('pub','fast_food','biergarten','cafe','pub','bar','nightclub') THEN 0.08
		    WHEN railway = 'station' THEN 0.4
		    WHEN railway = 'halt' THEN 0.3
		    WHEN railway = 'tram_stop' THEN 0.25
		    WHEN railway = 'subway_entrance' THEN 0.2
		    WHEN highway = 'bus_stop' THEN 0.24
		    WHEN amenity = 'embassy' THEN 0.12
		    WHEN tourism = 'zoo' THEN 1.5
		    WHEN shop IN ('mall','department_store') THEN 0.3
		    WHEN shop IN ('supermarket') THEN 0.05
		    WHEN amenity IN ('toilets') THEN 0.03
		    WHEN amenity IN ('swimming_pool') THEN 0.1
		    WHEN amenity IN ('post_box','bench','atm','telephone','fire_hydrant') THEN -0.1
		    WHEN sport IN ('swimming') THEN 0.05
		    ELSE 0
	    END
        )
        *
        (
        CASE
            WHEN tourism = 'attraction' THEN 1.3
            WHEN tourism = 'yes' THEN 1.1
            ELSE 1.0
        END
        )
$$ LANGUAGE SQL IMMUTABLE;


CREATE OR REPLACE FUNCTION layer_symbol_polygon(bbox GEOMETRY, zoom_level INT)
RETURNS TABLE(
    osm_id BIGINT,
    way GEOMETRY,
    grade REAL,
    type INT,
    name TEXT,
    historic TEXT,
    man_made TEXT,
    sport TEXT,
    military TEXT,
    tourism TEXT,
    amenity TEXT,
    shop TEXT,
    "natural" TEXT,
    leisure TEXT,
    building TEXT,
    ruins TEXT,
    "tower:type" TEXT,
    information TEXT,
    place_of_worship TEXT,
    "place_of_worship:type" TEXT,
    castle_type TEXT,
    railway TEXT,
    highway TEXT,
    aeroway TEXT,
    way_area REAL,
    wikipedia TEXT,
    website TEXT,
    power TEXT,
    colour TEXT,
    transport TEXT,
    public_transport TEXT,
    cargo TEXT,
    cuisine TEXT,
    parking TEXT,
    maxheight TEXT,
    fee TEXT,
    surveillance TEXT,
    memorial TEXT,
    operator TEXT,
    wiki TEXT,
) AS $$
    SELECT
        osm_id,
	    way,
	    get_symbol_grade(
            historic, castle_type, ruins, building, amenity, railway, tourism, highway, shop, sport, place_of_worship
        ) AS grade,
		get_symbol_type(
            historic, castle_type, ruins, building, amenity, railway, tourism, highway, shop, sport, place_of_worship
        ) AS type,
	    name,
	    historic,
	    man_made,
	    sport,
	    military,
	    tourism,
	    amenity,
	    shop,
	    "natural",
	    leisure,
	    building,
	    ruins,
	    "tower:type",
	    information,
	    place_of_worship,
	    "place_of_worship:type",
	    castle_type,
	    railway,
	    highway,
	    aeroway,
    	way_area,
    	wikipedia,
    	website,
	    power,
	    colour,
	    transport,
	    public_transport,
	    cargo,
	    cuisine,
	    parking,
	    maxheight,
	    fee,
	    surveillance,
	    memorial,
	    operator,
	    NULL AS wiki
        FROM (
	        SELECT osm_id,name,way,historic,man_made,shop,tourism,amenity,"natural",leisure,sport,military,building,ruins,"tower:type",information,place_of_worship,"place_of_worship:type",castle_type,railway,highway,aeroway,power,0 AS way_area, wikipedia, website,colour,transport,public_transport,cargo,cuisine,parking,maxheight,fee,surveillance,memorial,operator, z_order FROM symbol
        ) AS T
    WHERE way && bbox
    ORDER BY get_symbol_grade(
            historic, castle_type, ruins, building, amenity, railway, tourism, highway, shop, sport, place_of_worship
        ) DESC, COALESCE(way_area,0) DESC

$$ LANGUAGE SQL IMMUTABLE;