name = "Luke's simple cheaty method"
description = "Simple lon-5 with some edge case management. Reaches all children but with minimal distance travelled."

nchildren = 26       # [1, 26]
layer = 2           # [1, 8], 1 is top layer, 8 is surface layer

children = TravellingSailorProblem.children(nchildren)

departures = [
    let (lon, lat) = children[i].lonlat

        # compute both lon and lat depending on i
        newlon, newlat =
            i == 1 ? (lon + 5, lat) :         # case for child 1
            i == 3 ? (lon - 5, lat + 1) :     # case for child 3 (example: -5 lon, +3 lat)
            i == 9 ? (lon - 5, lat - 2) : # Isla
            i == 16 ? (lon - 7, lat + 0.1) : # Priya should be hitting?
            i == 20 ? (lon - 5, lat - 2.5) : # Tomas
            i == 22 ? (lon + 5, lat) : 
            i == 23 ? (lon - 5, lat + 1) : # Walter
            (lon - 5, lat)                    # default (all others)

        (newlon, newlat)
    end
    for i in eachindex(children)
]