# TravellingSailorProblem.jl
[![docs](https://img.shields.io/badge/documentation-main-blue.svg)](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/)
[![Build Status](https://github.com/SpeedyWeather/TravellingSailorProblem.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SpeedyWeather/TravellingSailorProblem.jl/actions/workflows/CI.yml?query=branch%3Amain)

[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) might be NP-hard, this is NP-very hard!

> Santa came to me in a gale of despair — his reindeer, mutinous and idle. 'Drake,' he said, 'how shall I deliver all the gifts?'
> I told him, 'Trim the sails and trust the wind, for the world has been circled before.'

_Sir Francis Drake_

<img width="795" height="791" alt="image" src="https://github.com/user-attachments/assets/e0e24d58-3ece-457c-9e1b-cb44549de808" />

## Example

```julia
using SpeedyWeather, TravellingSailorProblem

# create a simulation with 10 particles and particle advection
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=10)
particle_advection = ParticleAdvection2D(spectral_grid, layer=5)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 13))

# add 10 children as destinations
children = TravellingSailorProblem.children(10)
add!(model, children)

# add particle tracker
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

# adjust initial locations of particles
(; particles) = simulation.prognostic_variables
particles .= rand(Particle, 10)     # all 10 random
particles[1] = Particle(25, 35)     # or individually 25˚E, 35˚N
particles[2] = Particle(-120, 55)   # 120˚W, 55˚N

# then run! simulation until Christmas
run!(simulation, period=Day(41))

# evaluate
evaluate(particle_tracker, children)

# and visualise
using GLMakie
globe(children, particle_tracker)
```

## Evaluation

After the simulation ran, do

```julia
evaluate(particle_tracker, children)
```

and you'll see something like

```
Destination  1    Ana (-157.8˚E,  21.3˚N)  missed by particle  1: -10596 points
Destination  2   Babu ( 158.7˚E,  53.0˚N)  missed by particle  5:  -6340 points
Destination  3  Carla ( -74.1˚E,   4.7˚N)  missed by particle  2: -21213 points
Destination  4  Diego ( 151.2˚E, -33.9˚N)  missed by particle  4:  -2276 points
Destination  5   Elif (  85.3˚E,  27.7˚N)  missed by particle  1: -10635 points
Destination  6 Felipe ( 106.9˚E,  47.9˚N)  missed by particle  5: -10691 points
Destination  7   Gael ( -96.7˚E,  17.1˚N)  missed by particle  5: -25433 points
Destination  8 Haruko ( 115.9˚E, -31.9˚N) reached by particle  3:  12812 points
Destination  9   Isla (  -7.6˚E,  33.6˚N)  missed by particle  5: -23549 points
Destination 10   Jose ( 139.7˚E,  35.7˚N)  missed by particle  5:  -6099 points

Evaluation: 1/10 reached, -104020 points
```

Telling you for every child (=destination) the points, how many were reached
in total and the total points. Points are

- For every destination reached: 1 point per km of distance the particle flew before reaching the child.
- For every destination not reached: -10 points per km of distance to the closest particle came 

So to reach more points you want to

- fly particles as far as possible before reaching a child
- reach every child not to get minus points but the closer a particle gets the better

to make the optimization easier the evaluation will tell you which particles provided
points for a given destination. So in the example above 4, 5, 6, 7, and 9 do not
reach any destination or are the closest to one. So you probably want to let those
fly differently!

## Visualisation

You can visualise tracks and the children's locations via

```julia
using GLMakie
globe(children, particle_tracker)
```

and an interactive window will open where you can scroll and zoom. Particle trajectories have different colours
to distinguish them, destinations reached are in dark purple, destinations not reached in yellow.

https://github.com/user-attachments/assets/8a3ad5e8-2316-46c6-be5f-ffe851305d6c

## Installation

TravellingSailorProblem.jl is not yet a registered Julia packge so from the Julia REPL do

```julia
julia> ] add https://github.com/SpeedyWeather/TravellingSailorProblem.jl#main
```

where `]` opens Julia's package manager interactively, and `#main` to install the current main branch.
Alternatively you can do

```julia
using Pkg
Pkg.add(url="https://github.com/SpeedyWeather/TravellingSailorProblem.jl", rev="main")
```

SpeedyWeather is automatically installed as a dependency but to have it explicitly available just
do `add SpeedyWeather`. For visualisation you have to choose a backend for Makie, e.g. do

```julia
julia> ] add GLMakie
```

alternatively you can use WGLMakie.  Don't use CairoMakie, as it will not render the 3D properties correctly.

