# TravellingSailorProblem.jl

[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) might be NP-hard, this is NP-very hard!


## Example

```julia
using SpeedyWeather, TravellingSailorProblem

# create a simulation with 10 particles and particle advection
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=10)
particle_advection = ParticleAdvection2D(spectral_grid, layer=5)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 10))

# add 10 children as destinations
children = TravellingSailorProblem.children(10)
add!(model, children)

# add particle tracker
particle_tracker = ParticleTracker(spectral_grid)
add!(model, particle_tracker)

# adjust initial locations of particles
(; particles) = simulation.prognostic_variables
particles .= rand(Particle, 10)     # all 10 random
particles[1] = Particle(25, 35)     # or individually 25˚E, 35˚N
particles[2] = Particle(-120, 55)   # 120˚W, 55˚N

# then run! simulation
run!(simulation, period=Week(6))

# and evaluate
evaluate(children, particle_tracker)

# and visualise
using GLMakie
globe(children, particle_tracker)
```


