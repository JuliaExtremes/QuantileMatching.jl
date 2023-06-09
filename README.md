# QuantileMatching

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build status](https://github.com/JuliaExtremes/QuantileMatching.jl/workflows/CI/badge.svg)](https://github.com/JuliaExtremes/QuantileMatching.jl/actions)
[![codecov](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl/branch/main/graph/badge.svg?token=5fe36122-1af1-4494-be65-e307d5aa8acc)](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl)
[![documentation stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliaextremes.github.io/QuantileMatching.jl/stable/)
[![documentation latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliaextremes.github.io/QuantileMatching.jl/dev/)


TThe package provides several exhaustive high-performance functions to perform quantile matching (QM; see for example Panofsky and Brier, 1968 and Themeßl *et al.*, 2011) of an actual distribution and a target distribution. It also provides the functions for the non-stationary case (see for example Michelangeli *et al.*, 2009). 

See the [Package Documentation](https://JuliaExtremes.github.io/QuantileMatching.jl/stable/) for details and examples.

## Installation

The package can be installed with the Julia package manager as follows:

```julia
julia> import Pkg
julia> Pkg.add("QuantileMatching")
```

## Contributing

Contributions are welcomed. Here's the workflow for development of new features, refactoring and bugfix.

```
main                     # Stable branch, always ready to be tagged

dev                      # Development branch. New features, refactoring, bug and hotfix 
                         # are integrated into dev before going into master.
                        
feature/<feature-name>   # New feature needs a `feature` prefix
        
refactor/<refactor-name> # Refactoring are tagged with a `refactor` prefix
   
bug/<bug-fix>            # Prefix for bugs found during development
          
hotfix/<hot-fix>         # Prefix for hotfix (bugs for deployed versions)
      
```

### References

Michelangeli, P.-A., Vrac, M., and Loukos, H. (2009), Probabilistic downscaling approaches: 
Application to wind cumulative distribution functions, *Geophys. Res. Lett.*, 36, L11708, doi:10.1029/2009GL038401.

Panofsky, H. and Brier, G. (1968). Some Applications of Statistics to Meteorology, Earth and Mineral Sciences Continuing Education, College of
Earth and Mineral Sciences, The Pennsylvania State University.

Themeßl, M., Gobiet, A. and Leuprecht, A. (2011). Empirical-statistical downscaling and error correction of daily precipitation from regional
climate models, *International Journal of Climatology*, 31, 1530–1544, https://doi.org/https://doi.org/10.1002/joc.2168.