# TravellingSailorProblem instructions

First, get yourself familiar with

0. the general workflow to run a [SpeedyWeather](https://speedyweather.github.io/SpeedyWeather.jl/dev/how_to_run_speedy/) simulation
1. how do define `N` children as a [Destination](@ref)
2. how to setup [Particle advection](@ref) and choose departure locations
3. [Evaluation](@ref) of your Christmas present delivery
4. and [Visualising trajectories](@ref) so see where things have been blown!

With the information from 3&4 you can then change the number of children/particles,
and their departure locations (see [Initial conditions](@ref)) or vertical layer to fly on.
Then you can repeat and find better parameters (departure locations, number of children, layer to fly on)
to this problem.

## Tapping in the dark?

You can place as many particles as you like to explore the general circulation
of a SpeedyWeather simulation. Where does the wind blow in which parts of the globe?
Following the particles trajectories you follow the wind but beware weather is
chaotic and so are the trajectories of particles. This means two neighbouring
particles will sooner or later diverge, potentially ending up on other sides
of the globe. But there are also areas where the prevailing wind direction
is easily predictable and also largely laminar: So two particle stay close
to another for a long time. Explore the wind field by placing particles
in various places.

## Strategy 1: Start nearby

With `children = TravellingSailorProblem.children(5)` you know the locations
of the first 5 (or any really) children. Start your particles close to their
destinations that will make it much likelier that they reach their destination.
See [Initial conditions](@ref).
Combined with the knowledge of where the wind comes from you can then
reverse engineer where a particle could start from in order to reach the desired
destination.

## Strategy 2: Start small

Don't try to reach all 26 children in the first round. Familiarise yourself
with the best strategy to hit 1-3 children and if you found something that works
try to scale up!

## Strategy 3: Sharing is caring

But maybe also check with others that have already reached
a particular child. _Ana_ always lives in Winnipeg in each submission and the
wind also blows in the same way!
Team work is allowed, share your achievements, that's how open source software works!

## Strategy 4: Brute force

You can always try to place many particles but then you will also face several problems

- How to create reproducibly many particles evenly across the globe? (Hint, [Particle seeds](@ref))
- How to pick the best particles?
- In the final submission only as many particles as children (max 26) are allowed, not 10000.
- With too many particles some may reach their destination too late because another particle delivered to a destination first, this does not necessarily maximise points.

See also [Visualising trajectories](@ref) if you end up placing thousands of particles.