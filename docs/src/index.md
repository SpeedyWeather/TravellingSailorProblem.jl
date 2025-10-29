```@meta
CurrentModule = TravellingSailorProblem
```

# TravellingSailorProblem

Documentation for [TravellingSailorProblem](https://github.com/SpeedyWeather/TravellingSailorProblem.jl),
a repository to fly particles (like balloons) inside a
[SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl) simulation. 

## The Problem

The actual problem is:

> Reach N destinations with particles flying with the wind as far as possible or at least get
> as close as possible to the destinations. There will be positive points for longer distances
> particles have flown before reaching their destination and negative points proportional to the
> closest any particle ever came to that destination.

So it's only vaguely related to the
[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)
which is about minimizing a path you can choose. Here it's about maximising a path determined
by the (turbulent) wind field but you can choose the starting point.

Contents

- [Installation](@ref)
- [New to Julia?](@ref)
- [Destination](@ref)
- [Particle advection](@ref) including [Visualising trajectories](@ref)
- [TravellingSailorProblem instructions](@ref)
- [Submit to the TravellingSailorProblem](@ref)
- [TravellingSailorProblem leaderboard](@ref)
- [List of submissions](@ref)

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

