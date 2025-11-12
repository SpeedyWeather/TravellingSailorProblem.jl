# Submit to the TravellingSailorProblem

Once you are ready to submit your solution to the TravellingSailorProblem do
the following

1. Create a file like `flying_dutchman.jl`
2. In it, there needs to be several variables defined
- `name`: a `String` with your name, your group's name etc
- `description`: a `String` describing your submission in <10 words
- `nchildren`: an `Integer`, the number of children and particles, between 1 and 26
- `layer`: an `Integer`, the vertical layer the particles travel on, between 1 and 8
- `departures`: a vector of tuples determining the departures coordinates

plus some [Optional settings](@ref). For example such a file could look like

```julia
name = "Flying Dutchman and the Ghost"
description = "Five on the equator"

nchildren = 5   # number of children and particles
layer = 8       # vertical layer
departures = [
    (  5, 0),   # (lon, lat) in degrees, particle 1
    ( -5, 0),   # particle 2
    (-15, 0),   # etc
    (-25, 0),
    (-35, 0),
]
```

and create a pull request placing that file into the
[`/submissions` folder](https://github.com/SpeedyWeather/TravellingSailorProblem.jl/tree/main/submissions)
of the TravellingSailorProblem.jl repository. 

The file you submit is executed as a Julia script. This means you formatting does not matter 
as long as it is valid Julia code and particularly you can code in it, for example

```julia
departures = [(30, 30) .+ randn(2) for i in 1:3]
```

is a valid (yet not reproducible because of `randn`) way to create 3 particles around 30˚E, 30˚N.

The easiest is to have a look a existing submissions listed in
[List of submissions](@ref) and get some inspirations from
[TravellingSailorProblem instructions](@ref). The `author` and `description`
strings are used in the [List of submissions](@ref) and the [Leaderboard](@ref).

## Optional settings

In addition to `name`, `description` ... etc. your file _can_ but don't have to contain

- `NF = Float64` (or `Float32`, the default), the number format, in case you want to simulate at higher numerical precision
- `nsteps = 6` (the default) defines the step length of the particle advection, shorter steps yield smoother trajectories

## Rules

1. You can submit for 1, 2, ... 26 children but N children will always start with `Ana` and then follow the alphabet.
2. One particle per child.
3. Simulations start on 13 Nov 2025 and particles have to arrive by 24 Dec 2025 (41 days later).
4. Simulations use SpeedyWeather's default configuration at T31 spectral resolution and 8 vertical layers.
5. You can choose the layer particles fly on.
6. Points are given following the [Point system](@ref).
7. You can submit up to 10 unique submissions alone or in groups (don't overload GitHub actions with a million submissions).

In the end you can't really cheat because GitHub actions will evaluate your submission following these rules anyway...