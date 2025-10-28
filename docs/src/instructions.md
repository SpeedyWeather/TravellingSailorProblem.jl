# Travelling sailor problem instructions

## General workflow to run SpeedyWeather

There's more information in the [SpeedyWeather documentation](https://speedyweather.github.io/SpeedyWeather.jl/dev/how_to_run_speedy/)
but in short there are 4 steps

```julia
using SpeedyWeather

# 1. define the resolution
spectral_grid = SpectralGrid(trunc=31, nlayers=8)

# 2. create a model
model = PrimitiveWetModel(spectral_grid)

# 3. initialize the model
simulation = initialize!(model)

# 4. run the model
run!(simulation, period=Day(10))
```