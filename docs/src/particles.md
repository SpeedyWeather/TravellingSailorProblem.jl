# Particle advection

There are several steps for particle advection in SpeedyWeather.
Particle advection in general is described in more detail in

- [Particle advection](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/particles/)

Generally we do,

```@example particles
using TravellingSailorProblem, SpeedyWeather

# how many particles do you want when creating a spectral grid
spectral_grid = SpectralGrid(nparticles=10)

# create a particle advection component, choose the layer it's on
particle_advection = ParticleAdvection2D(spectral_grid, layer=8)

# pass the particle advection to the model constructor
model = PrimitiveWetModel(spectral_grid; particle_advection)

# define particle tracker and add to the model
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)
```

which is now explained in more detail

### `nparticles`

In SpeedyWeather, creating a `spectral_grid` means to choose the
resolution so that every component knows of which size to allocate
variables etc. Hence you have to decide here how many particles you
want by passing on the `nparticles` keyword argument. The number
of particles is then displayed

```@example particles
SpectralGrid(nparticles=100)
```

### `ParticleAdvection2D`

By default, SpeedyWeather does not advect any particles. So you have
to create a `ParticleAdvection2D` component (there is no 3D, yet, sorry!)
and the `spectral_grid` has to be passed on as the first argument
so the particle advection knows how many particles to advect!

```@example particles
ParticleAdvection2D(spectral_grid, layer=8)
```

As the advection is in 2D, on a given layer of a SpeedyWeather simulation
(so don't choose it higher than `nlayers` in `spectral_grid`!) you can
choose the `layer` here too. Layers are numbered 1 at the top of the atmosphere
to `nlayers` near the surface. There are other options but we won't change
those.

## Model constructor

In SpeedyWeather, `PrimitiveWetModel` is the model that solves the primitive
equations (widely used for weather forecasting) with humidity. It takes
the `spectral_grid` as the first argument and then keyword arguments for
every non-default model component. If you look at `model` it's quite lenghty
as it shows every single model component, from numerics, to output to
parameterizations that are used inside a simulation. But now
`model.particle_advection` is just the particle advection we just created,
it also lives inside the `model` now!

```@example particles
model = PrimitiveWetModel(spectral_grid; particle_advection)
model.particle_advection
```

## Particle tracker

So far the particles would fly but their trajectory wouldn't be tracked.
For that we create a particle tracker as follows, again passing on `spectral_grid`
as the first argument

```@example particles
particle_tracker = ParticleTracker(spectral_grid)
```

There's many options but we won't touch those or elaborate them here.
Important is however that creating a particle tracker doesn't mean it's
part of the model. For this we do

```@example particles
add!(model, :particle_tracker => particle_tracker)
```

As the `ParticleTracker` is implemented as a callback you can provide
a key (a name) for it, like here `:particle_tracker` but you could
also give it your own key like `:my_tracker` or simply do

```@example particles
add!(model, particle_tracker)
```

in which case a random key is chosen as printed with an `[ Info:` note.
But beware now we have added the same `particle_tracker` twice but with two
different keys in which case the same `particle_tracker` will be called
twice on every time step -- probably not a good idea. You can always check
which callbacks you have added with

```@example particles
model.callbacks
```

and delete callbacks with `delete!(model.callbacks, :key)`. 
We delete one particle tracker by specifying its key, so that only
the other one remains

```@example particles
delete!(model.callbacks, :particle_tracker)
```

Note that also the `children` are implemented as callbacks so you will likely see a list
of both `Destination`s (the children) and the particle tracker!

!!! warn "Do not add one particle tracker twice with different keys"
    Otherwise the second will interfere with the netCDF file created
    by the first.

## Initial conditions

When the `model` is initialized it returns a `simulation` which contains that `model`
as well as variables among which are the particles. We can therefore view those
particles by

```@example particles
simulation = initialize!(model)
(; particles) = simulation.prognostic_variables
particles
```

which is a `Vector{Particle{T}}` of some number format `T`. By default these
particle initial conditions are uniformly random across the globe
but you can manually choose the initial conditions with

```@example particles
particles[1] = Particle(-30, 50)  # lon, lat in degrees
```

You can use both (0, 360˚E) or (-180, 180˚E). Or create a random particle

```@example particles
particles[2] = rand(Particle)
```

Or a mix of both

```@example particles
particles[3] = Particle(-30, 50 + 5*randn())
```

## Particle seeds

`rand(Particle)` creates a random particle uniformly distributed over the globe
(not packed towards the poles ...). While this is random, it's not directly
reproducible. For that one can use a specific random number generator with
a predefined seed, e.g. the `Xoshiro` random number generator

```@example seed
using Random, SpeedyWeather

seed = 123
RNG = Xoshiro(seed)
rand(RNG, Particle)
```

places a particle in a location that is different from the next particle
(following a _random_ sequence)

```@example seed
rand(RNG, Particle)
```

but one can always revert to an earlier (or later) point in the sequence
by reseeding the random number generator

```@example seed
Random.seed!(RNG, seed)
rand(RNG, Particle)
```

## Visualising trajectories

Now let us also add some `children` as destinations

```@example particles
children = TravellingSailorProblem.children(10)
add!(model, children)
```

which automatically uses their respective names as keys, you can check this with

```@example particles
model.callbacks
```

Now we still need to initialize the model to obtain a simulation and run it!

```@example particles
simulation = initialize!(model)
run!(simulation, period=Day(41))
```

After this is complete we can investigate the particle trajectories with
`globe` passing on the particle tracker used and the children that were
added to the model

```@example particles
using GLMakie, GeoMakie
globe(particle_tracker, children)
save("trajectories1.png", ans) # hide
nothing # hide
```
![](trajectories1.png)

## Performance tips

You can probably advect thousands to millions of particles without problems,
but visualising many many particles can get tricky. Here are several arguments to
`globe` you can provide to speed things up

- `shadows=false`
- `track_labels=false` (automatically for 100 or more particles)
- or don't pass on the `children` as destinations, only the `particle_tracker`

It is probably also wise to only visualise shorts tracks even though many,
i.e. simulate particle tracks for a few days only, not weeks. Visualising
1000 particles advected for 1 day will give you a good overview of how
the wind is blowing. But note that the initial conditions are unlikely
representative for the remaining 41 days of a simulation. So
maybe you want to `run!(simulation, period=Week(1))` before adding
the particle tracker (or the children)!

## Many particles

Applying the ideas from [Performance tips](@ref) you could for example do

```@example particles
using SpeedyWeather, TravellingSailorProblem, GLMakie

# create a simulation with 10 particles and particle advection
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=10_000)
particle_advection = ParticleAdvection2D(spectral_grid, layer=8)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 13))
run!(simulation, period=Week(2))    # run for two weeks without tracking

# reset to random particle locations
(; particles) = simulation.prognostic_variables
for i in eachindex(particles)
    particles[i] = rand(Particle)
end

# add particle tracker
particle_tracker = ParticleTracker(spectral_grid)
add!(model, :particle_tracker => particle_tracker)

# now run for a day
run!(simulation, period=Day(1))

# visualise
globe(particle_tracker, perspective=(120, 30), shadows=false)
save("many_trajectories.png", ans) # hide
nothing # hide
```
![](many_trajectories.png)