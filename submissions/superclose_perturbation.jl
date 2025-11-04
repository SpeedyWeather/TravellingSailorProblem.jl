name = "Peter Pan"
description = "Westerlies"

nchildren = 5       # [1, 26]
layer = 5           # [1, 8], 1 is top layer, 8 is surface layer

# Locations (lon, lat) in degrees ˚E, ˚N of the first 10 children
departures = [
    ( -97.1,  49.9),
    ( 115.0,  -8.7),
    (  73.5,  -4.6),
    ( -51.7,  64.2),
    ( 121.0,  14.6),
]

# move all 5 degrees west
for i in eachindex(departures)
    lon, lat = departures[i]
    departures[i] = (lon - 5, lat)
end