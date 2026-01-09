name = "Wind Rider"
description = "Optimized westerly trajectories"

nchildren = 5       # [1, 26]
layer = 6           # [1, 8], 1 is top layer, 8 is surface layer

# Optimized departure locations (lon, lat) in degrees
# Strategy: Use westerlies at layer 6 with carefully tuned offsets
# Ana benefits from a long circumnavigation trajectory at offset 6
# Elif needs a larger offset of 50 degrees west to reach Manila

departures = [
    (-103.1,  49.9),  # Ana (Winnipeg) - 6 deg west offset
    ( 109.0,  -8.7),  # Babu (Bali) - 6 deg west offset
    (  67.5,  -4.6),  # Carla (Seychelles) - 6 deg west offset
    ( -57.7,  64.2),  # Diego (Nuuk) - 6 deg west offset
    (  71.0,  14.6),  # Elif (Manila) - 50 deg west offset
]
