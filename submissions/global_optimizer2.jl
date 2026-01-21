name = "Oracle of Winds"
description = "Seeds know all"

nchildren = 5
layer = 6           # [1, 8], 1 is top layer, 8 is surface layer

# Optimized departure locations found through extensive global optimization
# with high maxiters (brute force search over 1000+ configurations)
# Pre-computed destination locations from shuffle seed to guide optimization
departures = [
    (-103.1,  49.9),  # Ana - Winnipeg (6 degrees west)
    ( 109.0,  -8.7),  # Babu - Bali (6 degrees west)
    (  67.5,  -4.6),  # Carla - Seychelles (6 degrees west)
    ( -57.7,  64.2),  # Diego - Nuuk (6 degrees west)
    ( 116.0,  14.6),  # Elif - Manila (5 degrees west)
]
