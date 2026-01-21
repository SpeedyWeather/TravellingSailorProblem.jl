name = "ChrisRackauckas"
description = "Global optimization westerlies"

nchildren = 10      # [1, 26]
layer = 5           # [1, 8], 1 is top layer, 8 is surface layer

# Departures optimized using global search over wind patterns
# Strategy: Start particles 5 degrees west of destinations (westerlies flow west to east)
# Exception: Haruko at 3 degrees west (Cape Town mid-latitude southern hemisphere)
# Layer 5 provides good balance between reaching destinations and distance flown

departures = [
    (-102.1, 49.9),     # Ana (Winnipeg) - 5 deg west
    (110.0, -8.7),      # Babu (Bali) - 5 deg west
    (68.5, -4.6),       # Carla (Seychelles) - 5 deg west
    (-56.7, 64.2),      # Diego (Nuuk) - 5 deg west
    (116.0, 14.6),      # Elif (Manila) - 5 deg west
    (-75.7, -53.2),     # Felipe (Punta Arenas) - 5 deg west
    (101.8, 10.8),      # Gael (Ho Chi Minh) - 5 deg west
    (15.5, -33.9),      # Haruko (Cape Town) - 3 deg west (optimized)
    (-79.1, 4.7),       # Isla (Bogota) - 5 deg west
    (-6.3, 51.8),       # Jose (Oxford) - 5 deg west
]
