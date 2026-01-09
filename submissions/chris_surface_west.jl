name = "Chris R"
description = "Surface layer with westward offsets"

nchildren = 5
layer = 8       # Surface layer for 2x point multiplier

# Start 30 degrees west of the first 5 children locations
# Children 1-5 target locations (from shuffled PLACES):
departures = [
    (15.6 - 30, 78.2),      # Child 1: Svalbard
    (158.7 - 30, 53.0),     # Child 2: Kamchatka
    (-51.7 - 30, 64.2),     # Child 3: Nuuk
    (106.9 - 30, 47.9),     # Child 4: Ulaanbaatar
    (-97.1 - 30, 49.9),     # Child 5: Winnipeg
]
