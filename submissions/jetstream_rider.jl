name = "Jet Stream Rider"
description = "Riding the upper tropospheric jet"

nchildren = 5       # [1, 26]
layer = 4           # [1, 8], 1 is top layer, 8 is surface layer

# Optimized departure locations using grid search
# Layer 4 provides access to strong upper tropospheric winds (jet stream)
# Individual offsets were optimized: Ana=2, Babu=3, Carla=3, Diego=3, Elif=3
departures = [
    (-99.1, 49.9),   # Ana (Winnipeg) - 2 degrees west
    (112.0, -8.7),   # Babu (Bali) - 3 degrees west
    (70.5, -4.6),    # Carla (Seychelles) - 3 degrees west
    (-54.7, 64.2),   # Diego (Greenland) - 3 degrees west
    (118.0, 14.6),   # Elif (Manila) - 3 degrees west
]
