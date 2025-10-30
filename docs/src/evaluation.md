# Evaluation

To evaluate how many destionations you reached, delivering Christmas presents
to the respective children after the simulation ran, do

```julia
evaluate(particle_tracker, children)
```

Within the whole setup this is

```@example evaluation
using TravellingSailorProblem, SpeedyWeather

nchildren = 10
spectral_grid = SpectralGrid(nparticles=nchildren, nlayers=8)
particle_advection = ParticleAdvection2D(spectral_grid, layer=8)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model)

# define children and add to the model as destinations
children = TravellingSailorProblem.children(nchildren)
add!(model, children)

# define particle tracker and add to the model
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

run!(simulation, period=Day(41))

evaluate(particle_tracker, children)
```

