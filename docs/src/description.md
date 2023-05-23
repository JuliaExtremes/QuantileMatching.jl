# Quantile matching in Julia

The package provides several exhaustive high-performance functions to perform quantile matching (QM; see for example [Panofsky and Brier, 1968](https://digital.libraries.psu.edu/digital/collection/digitalbks2/id/48274/) and [Themeßl *et al.*, 2011](https://rmets.onlinelibrary.wiley.com/doi/10.1002/joc.2168)) of an actual distribution and a target distribution. It also provides the functions for the non-stationary case (see for example [Michelangeli *et al.*, 2009](https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2009GL038401)). 

Let $F_X$ be the actual cumulative distribution function (cdf) and $F_Y$ be the target cdf. Let $x$ be a realization of $F_X$. The basic idea of the QM method is to find the value $\tilde{x}$ such that

$$F_Y(\tilde{x}) = F_X(x).$$

Therefore,

$$\tilde{x} = F_Y^{-1} \left\lbrace F_X(x) \right\rbrace.$$

The package also provides functions for the CDF-t approach (Michelangeli *et al.*, 2009) which extends the quantile matching framework to the non-stationary context. Let $F_{X^\prime}$ be the projected cdf with respect to $F_X$. The CDF-t approach defines the projected target cdf $F_{Y^\prime}$ as follows:

$$F_{Y^\prime}(x) = F_Y \left[ F_X^{-1} \left\lbrace F_{X^\prime}(x) \right\rbrace \right].$$

If $x$ is a realization of the projected cdf $F_{X^\prime}$, then the corresponding value $\tilde{x}$ with respect to $F_{Y^\prime}$ is as follows:

$$\tilde{x} = F_{Y^\prime}^{-1} \left\lbrace F_{X^\prime}(x) \right\rbrace.$$

## Package interface

To perform quantile matching, the model has to be defined in a [`AbstractQuantileMatchingModel`](@ref) and the method [`match`](@ref) can be applied to correct the given values. 

If the cdfs are known, the [`ParametricQuantileMatchingModel`](@ref) structure can be defined and the [`match`](@ref) method can be applied to it to perform quantile matching. In practice, the cdfs are generally unknown. They can be estimated either non-parametrically using the empirical distribution function or using a parametric estimate. The first approach is known as empirical quantile matching and the second as parametric quantile matching. The parametric estimates can be used to define the [`ParametricQuantileMatchingModel`](@ref) structure. 

Turnkey solutions are also provided to automatically perform quantile matching from random samples of different distributions. See for example `eqm` and `pqm`. More details are available in the Example.

## Empirical Quantile Matching

For empirical quantile matching, the [`EmpiricalQuantileMatchingModel`](@ref) structure can be defined using

- a sample of the target distribution; 
- a sample of the actual distribution;
- a sample of the projected distribution. 

If the sample of the projected distribution is omitted, the matching method is stationary. Once the model is defined, the [`match`](@ref) method can be called to perform the matching.


## Parametric Quantile Matching

For parametric quantile matching, the [`ParametricQuantileMatchingModel`](@ref) structure can be defined using

- the target distribution; 
- the actual distribution;
- the projected distribution. 

Those distributions should be in the class of `UnivariateContinuousDistribution` of the Julia package [Distributions.jl](https://juliastats.org/Distributions.jl/stable/). If the projected distribution is omitted, the matching method is stationary. Once the model is defined, the [`match`](@ref) method can be called to perform the matching.


## Frequency adjustment


When working with a distribution having a mass at some point, such as 0 for precipitation, Themeßl *et al.* (2011) propose to censor the value of the realization $x^\star$ of the actual cdf as follows:

```math
    x = \begin{cases}
        0 & \text{ if } x^\star_i \leq u ;\\
        x^\star_i - u & \text{ if } x^\star_i > u.
        \end{cases}
```

where $u$ is the threshold for which the probability that $X$ exceeds $u$ is equal to the probability that $Y$ exceeds 0. Quantile matching can then be performed on the censored values. The frequency adjustment can be performed using the following functions:

- [`censor`](@ref);
- [`wet_threshold`](@ref);
- [`pwet`](@ref).

More details are available in the Example.

!!! note
    The library was developed with the idea of post-processing the outputs of numerical climate models. This is why several functions use terminology associated with climate sciences. The functions are however general enough to be applied to other contexts. For example, censoring can be done for a threshold different from 0.

## References

Michelangeli, P.-A., Vrac, M., and Loukos, H. (2009), Probabilistic downscaling approaches: 
Application to wind cumulative distribution functions, *Geophys. Res. Lett.*, 36, L11708, doi:10.1029/2009GL038401.

Panofsky, H. and Brier, G. (1968). Some Applications of Statistics to Meteorology, Earth and Mineral Sciences Continuing Education, College of
Earth and Mineral Sciences, The Pennsylvania State University.

Themeßl, M., Gobiet, A. and Leuprecht, A. (2011). Empirical-statistical downscaling and error correction of daily precipitation from regional
climate models, *International Journal of Climatology*, 31, 1530–1544, https://doi.org/https://doi.org/10.1002/joc.2168.