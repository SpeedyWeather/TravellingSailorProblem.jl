```@meta
CurrentModule = TravellingSailorProblem
```

# TravellingSailorProblem

Documentation for [TravellingSailorProblem](https://github.com/SpeedyWeather/TravellingSailorProblem.jl),
a repository to fly particles (like balloons) inside a
[SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl) simulation. 

## The Problem

The actual problem is:

> Reach N predefined destinations with particles flying with the wind, launched anywhere on the globe.
> There will be more points for longer distances particles have flown before reaching their destination
> but and negative points if they miss it.

So it's only vaguely related to the
[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)
which is about minimizing a path you can choose. Here it's about maximising a path determined
by the (turbulent) wind field but you can choose the starting point.

Contents

- [Installation](@ref)
- [New to Julia?](@ref)
- [Destination](@ref)
- [Particle advection](@ref) including [Visualising trajectories](@ref)
- [Evaluation](@ref)

And specifically for submitting to the TravellingSailorProblem:

- [TravellingSailorProblem instructions](@ref)
- [Submit to the TravellingSailorProblem](@ref)
- [TravellingSailorProblem leaderboard](@ref)
- [List of submissions](@ref)

## Quick start

After the [Installation](@ref) copy and paste this into your Julia REPL, notebook etc

```julia
using SpeedyWeather, TravellingSailorProblem

# create a simulation for 26 children
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=26)
particle_advection = ParticleAdvection2D(spectral_grid, layer=8)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 13))

# add 10 children as destinations
children = TravellingSailorProblem.children(26)
add!(model, children)

# add particle tracker
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

# adjust initial locations of particles
(; particles) = simulation.prognostic_variables
particles .= rand(Particle, 26)     # all 26 random (the default)
particles[1] = Particle(25, 35)     # or individually 25˚E, 35˚N
particles[2] = Particle(-120, 55)   # 120˚W, 55˚N
particles[3:10] .=                  # or several ones along the equator
  [Particle(lon, 0) for lon in 100:20:240]

# then run! simulation until Christmas
run!(simulation, period=Day(41))

# evaluate
evaluate(particle_tracker, children)

# and visualise
using GLMakie
globe(children, particle_tracker)
```

And you have the basic setup to create a simulation, place particles in it, run, evaluate and visualise.
Change the particle departures to score higher, see more information in the
[TravellingSailorProblem instructions](@ref).

## Installation

First [install Julia](https://julialang.org/install/) via `juliaup` (the recommended default way).
TravellingSailorProblem.jl is a registered Julia packge so from the Julia REPL you can then do

```julia
julia> ] add TravellingSailorProblem, SpeedyWeather, GLMakie
```

where `]` opens Julia's package manager interactively.
[SpeedyWeather](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/)
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

## Julia Jupyter kernel

To install a Julia kernel for Jupyter notebooks (assuming you already have jupyter notebooks installed) you need
a package called [IJulia](https://github.com/JuliaLang/IJulia.jl)

```julia
julia> ] add IJulia
```

After IJulia is installed do once

```julia
using IJulia
installkernel("Julia")
```

this will add a Julia kernel you can choose among other Python kernels in jupyter lab or jupyter notebooks.
