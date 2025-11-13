name = "Luke's simple cheaty method"
description = "Simple lon-5 with some edge case management. Reaches all children but with minimal distance travelled."

nchildren = 26       # [1, 26]
layer = 2           # [1, 8], 1 is top layer, 8 is surface layer

# -----
using SpeedyWeather, TravellingSailorProblem

numChildren = 26

# create a simulation for numChildren particles
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=numChildren)
particle_advection = ParticleAdvection2D(spectral_grid, layer=2) # [1, 8], 1 is top layer, 8 is surface layer
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 13))

# children (destinations)
children = TravellingSailorProblem.children(numChildren)
add!(model, children)

# particle tracker
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

# --- set initial positions: each child’s lon + 5°, same lat ---
(; particles) = simulation.prognostic_variables
T = eltype(particles)   # SpeedyWeather.Particle{Float32}

particles .= [
    let (lon, lat) = children[i].lonlat

        # compute both lon and lat depending on i
        newlon, newlat =
            i == 1 ? (lon + 5, lat) :         # case for child 1
            i == 3 ? (lon - 5, lat + 1) :     # case for child 3 (example: -5 lon, +3 lat)
            i == 9 ? (lon - 5, lat - 2) : # Isla
            i == 16 ? (lon - 7, lat + 0.1) : # Priya should be hitting?
            i == 20 ? (lon - 5, lat - 2.5) : # Tomas
            i == 22 ? (lon + 5, lat) : 
            i == 23 ? (lon - 5, lat + 1) : # Walter
            (lon - 5, lat)                    # default (all others)

        T(newlon, newlat)
    end
    for i in eachindex(children)
]

initial_particles = deepcopy(particles)

# run, evaluate, visualise
run!(simulation, period=Day(41))
evaluate(particle_tracker, children)

using GLMakie
globe(children, particle_tracker)

evaluate(particle_tracker, children)



# println("departures = [")
# for (i, P) in enumerate(particles)
#     lon = round(P.lon; digits=2)
#     lat = round(P.lat; digits=2)
#     println("    ($(rpad(lon, 6)), $(lpad(lat, 6))),   # particle $i")
# end
# println("]")

departures = [(p.lon, p.lat) for p in initial_particles]
