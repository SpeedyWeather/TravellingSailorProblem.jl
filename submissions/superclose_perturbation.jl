name = "Milan"
description = "Superclose + random perturbation"

nchildren = 5       # [1, 26]
layer = 5           # [1, 8], 1 is top layer, 8 is surface layer

# Locations (lon, lat) in degrees ˚E, ˚N of the first 10 children
departures = [
    (-157.8,  21.3),
    ( 158.7,  53.0),
    ( -74.1,   4.7),
    ( 151.2, -33.9),
    (  85.3,  27.7),
]

# perturb with std dev of 1 degree
σ = 1
for i in eachindex(departures)
    lon, lat = departures[i]
    departures[i] = (lon + σ*randn(), lat + σ*randn())
end