name = "Flying Dutchman"
description = "Big Foot on the Interstate 10"

nchildren = 5
layer = 1

# optional parameter:
# number of model time steps between particle advection/tracking steps
# fewer (shorter) steps yields smoother trajectories (default 6)
nsteps = 18       

departures = [
    ( -82, 30),     # (lon, lat) in degrees for particle 1
    ( -90, 31),     # particle 2
    ( -98, 32),     # etc
    (-106, 33),
    (-114, 34),
]
