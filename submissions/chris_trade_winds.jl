name = "Chris R"
description = "Trade winds eastward for tropics"

nchildren = 10
layer = 8       # Surface trade winds

# Mix strategy: west offset for high lat, east offset for tropics
# Trade winds blow E->W in tropics, westerlies blow W->E in mid-lat
departures = [
    (15.6 - 30, 78.2),      # High lat - westerlies
    (158.7 - 30, 53.0),     # High lat - westerlies
    (-51.7 - 30, 64.2),     # High lat - westerlies
    (106.9 - 30, 47.9),     # Mid lat - westerlies
    (-97.1 - 30, 49.9),     # Mid lat - westerlies
    (-96.7 + 30, 17.1),     # Tropical - trade winds (go east)
    (-7.6 - 30, 33.6),      # Mid lat - westerlies
    (106.8 + 30, 10.8),     # Tropical - trade winds
    (-74.1 + 30, 4.7),      # Tropical - trade winds
    (-157.8 + 30, 21.3),    # Subtropical - try east
]
