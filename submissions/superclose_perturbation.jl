name = "Milan"
description = "Superclose + random perturbation"

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

# perturb with std dev of 1 degree
σ = 1
for i in eachindex(departures)
    lon, lat = departures[i]
    departures[i] = (lon + σ*randn(), lat + σ*randn())
end