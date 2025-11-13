name = "Luke's simple cheaty method"
description = "Simple lon-5 with some edge case management. Reaches all children but with minimal distance travelled."

nchildren = 26       # [1, 26]
layer = 2           # [1, 8], 1 is top layer, 8 is surface layer

departures = [
    (264.06,  50.23),   # particle 1
    (114.95,  -9.17),   # particle 2
    (73.3  ,  -4.76),   # particle 3
    (308.7 ,   64.1),   # particle 4
    (121.1 ,  14.29),   # particle 5
    (290.76, -53.13),   # particle 6
    (106.94,  10.09),   # particle 7
    (18.19 , -34.43),   # particle 8
    (285.69,   3.99),   # particle 9
    (0.13  ,  51.83),   # particle 10
    (139.7 ,  35.65),   # particle 11
    (201.66,  21.83),   # particle 12
    (263.44,  17.56),   # particle 13
    (115.24, -32.19),   # particle 14
    (163.51,  -77.6),   # particle 15
    (106.88,  47.68),   # particle 16
    (150.91, -34.02),   # particle 17
    (13.07 ,  78.19),   # particle 18
    (189.59, -21.72),   # particle 19
    (298.04,  10.47),   # particle 20
    (160.06,  52.85),   # particle 21
    (15.84 ,   3.73),   # particle 22
    (354.32, -16.48),   # particle 23
    (85.13 ,  27.64),   # particle 24
    (311.3 , -16.23),   # particle 25
    (351.88,  33.93),   # particle 26
]


# --LOGIC USED:

# particles .= [
#     let (lon, lat) = children[i].lonlat

#         # compute both lon and lat depending on i
#         newlon, newlat =
#             i == 1 ? (lon + 5, lat) :         # case for child 1
#             i == 3 ? (lon - 5, lat + 1) :     # case for child 3 (example: -5 lon, +3 lat)
#             i == 9 ? (lon - 5, lat - 2) : # Isla
#             i == 16 ? (lon - 7, lat + 0.1) : # Priya should be hitting?
#             i == 20 ? (lon - 5, lat - 2.5) : # Tomas
#             i == 22 ? (lon + 5, lat) : 
#             i == 23 ? (lon - 5, lat + 1) : # Walter
#             (lon - 5, lat)                    # default (all others)

#         T(newlon, newlat)
#     end
#     for i in eachindex(children)
# ]
