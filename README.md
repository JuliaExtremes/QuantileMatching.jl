# QuantileMatching

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build status](https://github.com/JuliaExtremes/QuantileMatching.jl/workflows/CI/badge.svg)](https://github.com/JuliaExtremes/QuantileMatching.jl/actions)
[![codecov](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl/branch/main/graph/badge.svg?token=5fe36122-1af1-4494-be65-e307d5aa8acc)](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl)

The package provides several functions to perform quantile matching (QM; sea for example Panofsky and Brier, 1968 and Themeßl *et al.*, 2011) of an actual distribution and a target distribution (QM). 

Let $F_X$ be the actual cumulative distribution function and $F_Y$ be the target cumulative distribition function. Let $x$ be a realization of $F_X$. The basic idea of the QM method is to find the value $\tilde{x}$ such that

$$F_Y(\tilde{x}) = F_X(x).$$

Therefore,

$$\tilde{x} = F_Y^{-1} \left\lbrace F_X(x) \right\rbrace.$$

The package also provides functions for the CDF-t approach (Michelangeli *et al., 2009) which extends the quantile matching framework to the non-stationary context. Let $F_{X^\prime}$ be the cumulative distribution function projected with respect to $F_X$. The CDF-t approach defines the projected target cumulative distribution function $F_{Y^\prime}$ as follows:

$$F_{Y^\prime}(x) = F_Y \left[ F_X^{-1} \left\lbrace F_{X^\prime}(x) \right\rbrace \right].$$

Let $x$ be a realization of the projected cdf $F_{X^\prime}$. The corresponding value with respect to F_{Y\prime} is as follows:

$$\tilde{x} = F_{Y^\prime}^{-1} \left\lbrace F_{X^\prime}(x) \right\rbrace.$$


### References

Michelangeli, P.-A., Vrac, M., and Loukos, H. (2009), Probabilistic downscaling approaches: 
Application to wind cumulative distribution functions, *Geophys. Res. Lett.*, 36, L11708, doi:10.1029/2009GL038401.

Panofsky, H. and Brier, G. (1968). Some Applications of Statistics to Meteorology, Earth and Mineral Sciences Continuing Education, College of
Earth and Mineral Sciences, The Pennsylvania State University.

Themeßl, M., Gobiet, A. and Leuprecht, A. (2011). Empirical-statistical downscaling and error correction of daily precipitation from regional
climate models, *International Journal of Climatology*, 31, 1530–1544, https://doi.org/https://doi.org/10.1002/joc.2168.
"""