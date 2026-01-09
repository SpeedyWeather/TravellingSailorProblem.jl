name = "Chris R"
description = "Equatorial belt targets"

# Focus on destinations near equator with trade wind strategy
nchildren = 26
layer = 8

# All 26 children, using latitude-aware offsets
PLACES_SHUFFLED = [
    (15.6, 78.2),       # 1
    (158.7, 53.0),      # 2
    (-51.7, 64.2),      # 3
    (106.9, 47.9),      # 4
    (-97.1, 49.9),      # 5
    (-96.7, 17.1),      # 6
    (-7.6, 33.6),       # 7
    (106.8, 10.8),      # 8
    (-74.1, 4.7),       # 9
    (-157.8, 21.3),     # 10
    (15.3, 4.4),        # 11
    (115.9, -31.9),     # 12
    (-47.9, -15.8),     # 13
    (151.2, -33.9),     # 14
    (-5.9, -15.9),      # 15
    (115.0, -8.7),      # 16
    (-70.7, -53.2),     # 17
    (85.3, 27.7),       # 18
    (-61.5, 10.5),      # 19
    (121.0, 14.6),      # 20
    (139.7, 35.7),      # 21
    (73.5, -4.6),       # 22
    (-169.9, -21.2),    # 23
    (18.5, -33.9),      # 24
    (166.7, -77.8),     # 25
    (-1.3, 51.8),       # 26
]

departures = [(lon - 20 * sign(lat > 20 ? 1 : lat < -20 ? 1 : -1), lat)
              for (lon, lat) in PLACES_SHUFFLED]
