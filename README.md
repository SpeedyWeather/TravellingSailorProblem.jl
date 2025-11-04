# TravellingSailorProblem.jl
[![docs](https://img.shields.io/badge/documentation-main-blue.svg)](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/)
[![Build Status](https://github.com/SpeedyWeather/TravellingSailorProblem.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SpeedyWeather/TravellingSailorProblem.jl/actions/workflows/CI.yml?query=branch%3Amain)

[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) might be NP-hard, this is NP-very hard!

> Santa came to me in a gale of despair — his reindeer, mutinous and idle. 'Drake,' he said, 'how shall I deliver all the gifts?'
> I told him, 'Trim the sails and trust the wind, for the world has been circled before.'

_Sir Francis Drake_

<img width="795" height="791" alt="image" src="https://github.com/user-attachments/assets/47002805-b8ed-4f61-97bf-1dc9812dd179" />

## The Problem

The actual problem is:

> Reach N predefined destinations with particles flying with the wind, launched anywhere on the globe.
> There will be more points for longer distances particles have flown before reaching their destination
> but and negative points if they miss it.

So it's only vaguely related to the
[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)
which is about minimizing a path you can choose. Here it's about maximising a path determined
by the (turbulent) wind field simulated by SpeedyWeather but you can choose the starting point.

See the [Documentation](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/) for more details!

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

See [Evaluation](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/evaluation/)
in the documentation for more details!

## Visualisation

You can visualise tracks and the children's locations via

```julia
using GLMakie
globe(children, particle_tracker)
```

and an interactive window will open where you can scroll and zoom. Particle trajectories have different colours
to distinguish them, destinations reached are in dark purple, destinations not reached in yellow.
See [Visualising trajectories](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/particles/#Visualising-trajectories)
for more details!

https://github.com/user-attachments/assets/0c0fb12d-cab5-4a47-b06f-8cf9462450db

## How to submit

See [Submit](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/submit/) in the
[Documentation](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/)

- [Leaderboard](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/leaderboard/)
- [List of submissions](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/submissions/)
- [Instructions](https://speedyweather.github.io/TravellingSailorProblem.jl/dev/instructions/)

## Installation

First [install Julia](https://julialang.org/install/) via `juliaup` (the recommended default way).
TravellingSailorProblem.jl is a registered Julia packge so from the Julia REPL you can then do

```julia
julia> ] add TravellingSailorProblem, SpeedyWeather, GLMakie
```

where `]` opens Julia's package manager interactively. [SpeedyWeather](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/)
is a dependency anyway and you will need its exported function and types to run a simulation.
[GLMakie](https://docs.makie.org/stable/explanations/backends/backends) is [Makie](https://docs.makie.org/stable/)'s
backend we use for visualisation: static and 3D+interactive. Don't use CairoMakie, as it will not render the 3D properties correctly.
Equivalently, you can do

```julia
using Pkg
Pkg.add(["TravellingSailorProblem", "SpeedyWeather", "GLMakie"])
```

and after all dependencies are installed with `julia> using TravellingSailorProblem, SpeedyWeather, GLMakie` you load the packages,
ready to solve the TravellingSailorProblem!

You can use this software in different ways,

- in [VS Code](https://code.visualstudio.com/docs/languages/julia)
- via [IJulia](https://github.com/JuliaLang/IJulia.jl) in [Jupyter notebooks](https://jupyter.org/)
- in [Pluto notebooks](https://github.com/fonsp/Pluto.jl)
- in the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) (the standard terminal)
- or [oldschool](https://docs.julialang.org/en/v1/manual/command-line-interface/) via `julia my_script.jl`

Coming from Python? Have a look at a concise list of
[noteworthy differences](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-differences-from-Python).
