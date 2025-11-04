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
