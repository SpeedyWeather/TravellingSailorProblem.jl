# Destination

More to come ... 

## Visualising destinations

```@example destination
using TravellingSailorProblem, GLMakie, GeoMakie

children = TravellingSailorProblem.children(26)
globe(children)
globe(children, return_figure=true) # hide
save("destination26.png", ans) # hide
nothing # hide
```
![](destination26.png)



## Functions and types

```@index
```

```@autodocs
Modules = [TravellingSailorProblem]
```


