# Evaluation

To evaluate how many destionations you reached, delivering Christmas presents
to the respective children after the simulation ran, do

```julia
evaluate(particle_tracker, children)
```

Within the whole setup this is

```@example evaluation
using TravellingSailorProblem, SpeedyWeather

nchildren = 26
spectral_grid = SpectralGrid(nparticles=nchildren, nlayers=8)
particle_advection = ParticleAdvection2D(spectral_grid, layer=8)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 13))

# define children and add to the model as destinations
children = TravellingSailorProblem.children(nchildren)
add!(model, children)

# define particle tracker and add to the model
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

run!(simulation, period=Day(41))

evaluate(particle_tracker, children)
```

And the last line will print you a list of all children and whether
they have been reached or not, the respective points you got from
each child (positive for reached, negative for missed) and a summary
of points. The aim of the TravellingSailorProblem is to maximize
the amount of points by reaching as many children as possible
with particles flying as far as possible before reaching a child.

## Point system

We give

```@example evaluation
TravellingSailorProblem.POINTS_PER_KM_REACHED
```

positive point(s) for each km a particle flew before reaching
its destination. A child would get more excited the further 
their Christmas present flew? Imagine you get a Christmas present
that flew through both the Arctic as well as Antarctica!

Additionally, we use

```@example evaluation
TravellingSailorProblem.POINT_FACTOR_AT_SURFACE
```

times higher points for particles that flew on the lowermost
vertical layer compared to the uppermost. This calculation is done in
[Sigma-coordinates](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/primitiveequation/#Sigma-coordinates)
so when choosing `layer=1` (top) one gets 1.0625 points per km flown,
but on `layer=8` (surface) one gets 1.9375 points per km flown.
The reason is that the wind is more turbulent
at the surface but more laminar higher up. To incentivise
low-flying presents we therefore introduced this point-multiplier.

However, if a child doesn't get a Christmas present we give

```@example evaluation
TravellingSailorProblem.POINTS_PER_KM_MISSED
```

(note: NEGATIVE!) points for every km the closest particle ever was
to a child. If you live on Hawai'i and no particle doesn't
even get near you, you would also be pretty disappointed no?
This incetivises you to get as close as possible to a child
and you get less penalised if you barely miss it compared to
not even trying to fly a present near it! Note the
point mutiplier does not apply for missed children, negative
points are the same on every vertical layer.

## Evaluate submission script

In [Submit to the TravellingSailorProblem](@ref) we illustrate a submission
by using a script `filename.jl` which contains

```@example evaluation2
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

You can shortcut the evaluation following the procedure in the
[TravellingSailorProblem leaderboard](@ref) by doing

```@example evaluation2
using TravellingSailorProblem, SpeedyWeather # hide
particle_tracker, children = run_submission(nchildren=nchildren, layer=layer, departures=departures)
evaluate(particle_tracker, children)
```

The first line will use `nchildren`, `layer` and `departures` to run a simulation with the
default setup and return [Particle tracker](@ref) and `children` (the [Destination](@ref)s).
The second line will then evaluate those and return points as described in [Evaluation](@ref).
And based on `particle_tracker` and `children` you can then also [Visualising trajectories](@ref).