```@meta
CurrentModule = TravellingSailorProblem
```

# TravellingSailorProblem

Documentation for [TravellingSailorProblem](https://github.com/SpeedyWeather/TravellingSailorProblem.jl),
a repository to fly particles inside a
[SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl) simulation.


Contents

- [Installation](@ref)
- [New to Julia?](@ref)
- [Destination](@ref)
- [Particle advection](@ref)
- [Visualisation](@ref)
- [Travelling sailor problem instructions](@ref)
- [Submit to the travelling sailor problem](@ref)
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

