# Destination

A `Destionation` is a
[SpeedyWeather callback](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/callbacks/#Callbacks)
that will check after every time step how close particles
(see [Particle advection](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/particles/))
are and decide whether one particle reached that destination (within a given radius) and mark itself as `reached`
and deactivate that particle.

## Predefined destinations

For the TravellingSailorProblem there are 26 predefined destinations. In analogy to delivering Christmas
presents to children around the world these are

```@example destination
using TravellingSailorProblem
children = TravellingSailorProblem.children(26)
```

Their names are in alphabetical order for easier identification when [Visualising destinations](@ref),
their respective locations are the same for every user of TravellingSailorProblem.
Initially they are set to `reached=false` as they haven't received any parcels (=Christmas present)
yet. 
You can create fewer destinations which will just pick the first N of those 26, e.g.

```@example destination
children = TravellingSailorProblem.children(5)
```

## Visualising destinations

The 26 destinations (children) are somewhat uniformly distributed all over the globe in various places (all on land).
You can visualise those locations with

```@example destination
using TravellingSailorProblem, GLMakie, GeoMakie

children = TravellingSailorProblem.children(26)
globe(children)
save("destination26.png", ans) # hide
nothing # hide
```
![](destination26.png)

which marks every destination (=child) with the first letter of their name. Choosing fewer children will
only visualise those. If you want the perspective on a particular destination you can pass that on as
`perspective = destination`, e.g. `children[2]` is a destination (`children` is a tuple of destinations)
if you have at least 2 children defined

```@example destination
using TravellingSailorProblem, GLMakie, GeoMakie

children = TravellingSailorProblem.children(26)
globe(children, perspective=children[2])
save("destination2.png", ans) # hide
nothing # hide
```
![](destination2.png)

In this documentation that visualisation is static but if you do this in the Julia REPL
you will get an interactive visualisation where you can rotate and zoom.
You can also provide a perspective with coordinates, e.g. `perspective = (0, 52)` to look down onto London, UK.

You can also change the altitude, typical values are between 1e6 (country level) and 2e7 (global view), e.g. to zoom onto London do

```@example destination
globe(children, perspective=(0, 52), altitude=1e6)
save("destination_london.png", ans) # hide
nothing # hide
```
![](destination_london.png)

By default a "shadow" is visualised below each destination to
illustrate its radius a particle has to reach for the destination to be
marked "reached". Unreached/missed destinations are marked in yellow but
they turn purple if a particle gets within the radius!
