# TravellingSailorProblem.jl

[Travelling Salesman problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) might be NP-hard, this is NP-very hard!

Otherwise something like this

<img width="800" height="600" alt="image" src="https://github.com/user-attachments/assets/04b01c54-c632-4285-9a24-1411f676e8d7" />


## Example

```julia
using SpeedyWeather, TravellingSailorProblem

# create a simulation with 10 particles and particle advection
spectral_grid = SpectralGrid(trunc=31, nlayers=8, nparticles=10)
particle_advection = ParticleAdvection2D(spectral_grid, layer=5)
model = PrimitiveWetModel(spectral_grid; particle_advection)
simulation = initialize!(model, time=DateTime(2025, 11, 10))

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

# then run! simulation
run!(simulation, period=Week(1))

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
Destination      Gael (  12.0˚E,  57.7˚N) from particle    8:  -1492 points
Destination     Aarav ( 151.2˚E, -33.9˚N) from particle    3: -51002 points
Destination     Imran (   3.2˚E,  51.2˚N) from particle    8:  -4664 points
Destination    Malika ( -58.4˚E, -34.6˚N) from particle   10: -55082 points
Destination    Hassan ( 121.6˚E,  25.0˚N) from particle    1: -10442 points
Destination     Maeve (  -1.5˚E,  53.8˚N) from particle    8:  49260 points
Destination      Emil (  -3.7˚E,  40.4˚N) from particle    1:  -8632 points
Destination     Priya (   2.4˚E,  48.9˚N) from particle    8:  -6240 points
Destination     Diego ( -79.4˚E,  43.7˚N) from particle    2:  51132 points
Destination     Elena (-122.4˚E,  37.8˚N) from particle    1:  -8256 points
Evaluation: 2/10 reached, -45418 points
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


https://github.com/user-attachments/assets/e6979621-6304-4d92-afd6-0fe298d7862b

