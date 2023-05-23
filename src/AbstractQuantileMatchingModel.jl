
"""
    AbstractQuantileMatchingModel

Abstract type containing the concrete types [`EmpiricalQuantileMatchingModel`](@ref) and [`ParametricQuantileMatchingModel`](@ref).
"""
abstract type AbstractQuantileMatchingModel end

abstract type Stationary end
abstract type NonStationary end

"""
    match(qmm::AbstractQuantileMappingModel, x::Vector{<:Real})

Match the values in `x` according to the model `qmm`.

## Details

The function uses the cdf-t method proposed by Michelangeli *et al.* (2009).

This is a type-stable function. This is why  it takes a vector as argument and returns a vector. 
For matching a scalar value `x`, wrap it in the vector `[x`].

### Reference
Michelangeli, P.-A., Vrac, M., and Loukos, H. (2009), Probabilistic downscaling approaches: 
Application to wind cumulative distribution functions, *Geophys. Res. Lett.*, 36, L11708, doi:10.1029/2009GL038401.
"""
function match end



include("AbstractQuantileMatchingModel/EmpiricalQuantileMatchingModel.jl")
include("AbstractQuantileMatchingModel/ParametricQuantileMatchingModel.jl")
