# Destination

A `Destionation` is a
[SpeedyWeather callback](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/callbacks/#Callbacks)
that will check after every time step how close particles
(see [Particle advection](https://speedyweather.github.io/SpeedyWeatherDocumentation/dev/particles/))
are and decide whether one particle reached that destination (within a given radius) and mark itself as `reached`
and deactivate that particle.

## Predefined destinations

For the TravellinSailorProblem there are 26 predefined destinations. In analogy to delivering Christmas
presents to children around the world these are

```@example destination
using TravellingSailorProblem
children = TravellingSailorProblem.children(26)
```

Their names are in alphabetical order for easier identification when [Visualising destinations](@ref),
their respective locations are the same for every user of TravellingSailorProblem. 
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
globe(children, return_figure=true) # hide
save("destination26.png", ans) # hide
nothing # hide
```
![](destination26.png)

which marks every destination (=child) with the first letter of their name. Choosing fewer children will
only visualise those. If you want the perspective on a particular destination you can pass that on as
`perspective = destination`, e.g. `children[1]` is a destination (`children` is a tuple of destinations)

```@example destination
using TravellingSailorProblem, GLMakie, GeoMakie

children = TravellingSailorProblem.children(26)
globe(children, perspective=children[1])
globe(children, perspective=children[1], return_figure=true) # hide
save("destination1.png", ans) # hide
nothing # hide
```
![](destination1.png)




In this documentation that visualisation is static but if you do this in the Julia REPL
you will get an interactive visualisation where you can rotate and zoom.