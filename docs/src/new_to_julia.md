# New to Julia?

The following lists some useful links if you are new to Julia and
want to use TravellingSailorProblem.jl and SpeedyWeather.jl for education or research.

## Install Julia

First of all you have to install Julia, the recommended way is using
the installation manager for Julia called [Juliaup](https://github.com/JuliaLang/juliaup), see here

- [Install Julia](https://julialang.org/downloads/)

## Julia kernel for Jupyter notebooks

Then you may want to use Julia inside [Jupyter Notebooks](https://jupyter.org/)
(the "Ju" in "Jupyter" is for Julia!)
for this you need to install [IJulia](https://github.com/JuliaLang/IJulia.jl)
which you can do through Julia's built-in package manager [Pkg.jl](https://pkgdocs.julialang.org/v1/),
this is as easy as

```julia
julia> ] add IJulia
```

where `]` opens the package manger. After this installing a Julia kernel for Jupyter is just

```julia
julia> using IJulia
julia> installkernel("Julia")
```

and you can choose "Julia" as a kernel in a Jupyter notebook.

## Julia documentation, tutorials and community resources

- [JuliaLang documentation](https://docs.julialang.org/en/v1/), particularly
    - [Differences from Matlab/R/Python](https://docs.julialang.org/en/v1/manual/noteworthy-differences/#Noteworthy-Differences-from-other-Languages)
- [Learn Julia in y minutes](https://learnxinyminutes.com/docs/julia/)
- [Julia's discourse forum](https://discourse.julialang.org/)
- [Join the Julia slack](https://julialang.org/slack/) and [Zulip channel](https://julialang.zulipchat.com/register/)
- [Julia's YouTube channel](https://www.youtube.com/user/JuliaLanguage)
- [Tutorials and books](https://julialang.org/learning/)

## SpeedyWeather documentation

Because TravellingSailorProblem.jl is built on top of
[SpeedyWeather.jl](https://github.com/SpeedyWeather/SpeedyWeather.jl)
do have a look at the documentation therein which explains how to run and modify
SpeedyWeather.

- [SpeedyWeather.jl documentation](https://speedyweather.github.io/SpeedyWeather.jl/stable/)