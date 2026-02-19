name = "Chris R"
description = "Focus on 3 high-latitude targets"

nchildren = 3
layer = 5       # Westerlies level

# Target only first 3 children - all high latitude
# Start significantly west for long flight distances
departures = [
    (15.6 - 60, 78.2),      # Svalbard
    (158.7 - 60, 53.0),     # Kamchatka
    (-51.7 - 60, 64.2),     # Nuuk
]
