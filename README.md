# QuantileMatching

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Build status](https://github.com/JuliaExtremes/QuantileMatching.jl/workflows/CI/badge.svg)](https://github.com/JuliaExtremes/QuantileMatching.jl/actions)
[![codecov](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl/branch/main/graph/badge.svg?token=5fe36122-1af1-4494-be65-e307d5aa8acc)](https://codecov.io/gh/JuliaExtremes/QuantileMatching.jl)

The package provides several functions to perform quantile matching (QM; sea for example Panofsky and Brier, 1968 and Themeßl *et al.*, 2011) of an actual distribution and a target distribution (QM). Let $F_X$ be the actual cumulative distribution function and $F_Y$ be the target cumulative distribition function. Let $x$ be a realization of $F_X$. The basic idea of the QM method is to find the value $\tilde{x}$ such that

$$F_Y(\tilde{x}) = F_X(x).$$

Therefore,

$$\tilde{x} = F_Y^{-1} \left\{ F_X(x) \right\}.$$


### Reference

Panofsky, H. and Brier, G. (1968). Some Applications of Statistics to Meteorology, Earth and Mineral Sciences Continuing Education, College of
Earth and Mineral Sciences, The Pennsylvania State University.

Themeßl, M., Gobiet, A. and Leuprecht, A. (2011). Empirical-statistical downscaling and error correction of daily precipitation from regional
climate models, *International Journal of Climatology*, 31, 1530–1544, https://doi.org/https://doi.org/10.1002/joc.2168.
"""