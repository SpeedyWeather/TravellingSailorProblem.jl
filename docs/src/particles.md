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
globe(particle_tracker, children, return_figure=true) # hide
save("trajectories1.png", ans) # hide
nothing # hide
```
![](trajectories1.png)