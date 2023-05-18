
"""
    ParametricQuantileMatchingModel{T}

Structure containing the different distributions for performing parametric quantile matching.

## Details

- `targetdist`: target distribution (local-scale distribution for the calibration period)
- `actualdist`: actual distribution (large-scale distribution for the calibration period)
- `projdist`: projected distribution (large-scale distribution for the projected period)

If the `projdist` is not provided, the quantile matching model is assumed to be stationary and the actual distribution is post-processed.

See also [`EmpiricalQuantileMatchingModel`](@ref)
"""
struct ParametricQuantileMatchingModel{T} <: AbstractQuantileMatchingModel
    targetdist::UnivariateDistribution
    actualdist::UnivariateDistribution
    projdist::UnivariateDistribution
end 

function ParametricQuantileMatchingModel(targetdist::UnivariateDistribution, actualdist::UnivariateDistribution)
    return ParametricQuantileMatchingModel{Stationary}(targetdist, actualdist, actualdist)
end

function ParametricQuantileMatchingModel(targetdist::UnivariateDistribution, actualdist::UnivariateDistribution, projdist::UnivariateDistribution)
    return ParametricQuantileMatchingModel{NonStationary}(targetdist, actualdist, projdist)
end

function get_actualdist(qmm::ParametricQuantileMatchingModel)
    return qmm.actualdist
end

function get_targetdist(qmm::ParametricQuantileMatchingModel)
    return qmm.targetdist
end

function get_projdist(qmm::ParametricQuantileMatchingModel)
    return qmm.projdist
end

function Base.show(io::IO, obj::ParametricQuantileMatchingModel{T} where T)
    showParametricQuantileMatchingModel(io, obj)
end

function showParametricQuantileMatchingModel(io::IO, obj::ParametricQuantileMatchingModel{Stationary}; prefix::String = "")
    println(io, prefix, "ParametricQuantileMatchingModel{Stationary}")
    println(io, prefix, "    ", "targetdist: ", get_targetdist(obj))
    println(io, prefix, "    ", "actualdist: ", get_actualdist(obj))
end

function showParametricQuantileMatchingModel(io::IO, obj::ParametricQuantileMatchingModel{NonStationary}; prefix::String = "")
    println(io, prefix, "ParametricQuantileMatchingModel{NonStationary}")
    println(io, prefix, "    ", "targetdist: ", get_targetdist(obj))
    println(io, prefix, "    ", "actualdist: ", get_actualdist(obj))
    println(io, prefix, "    ", "projdist: ", get_projdist(obj))
end


function match(pqm::ParametricQuantileMatchingModel{Stationary}, x::Vector{<:Real})
    
    targetdist = get_targetdist(pqm)
    actualdist = get_actualdist(pqm)
          
    p = cdf.(actualdist, x)
    
    x̃ = quantile.(targetdist, p)
    
    return x̃
    
end

function match(nspqm::ParametricQuantileMatchingModel{NonStationary}, x::Vector{<:Real})
    
    targetdist = get_targetdist(nspqm)
    actualdist = get_actualdist(nspqm)
    projdist = get_projdist(nspqm)
    
    z = match(ParametricQuantileMatchingModel(targetdist, projdist), x)
    x̃ = match(ParametricQuantileMatchingModel(projdist, actualdist), z)
    
    return x̃
    
end

"""
    projcdf(nspqm::ParametricQuantileMatchingModel, x::Real)

Compute the post-processed cdf of the projections using the cdf-t approach.

See also [`projquantile`](@ref).
"""
function projcdf(nspqm::ParametricQuantileMatchingModel, x::Real)
    
    targetdist = get_targetdist(nspqm)
    actualdist = get_actualdist(nspqm)
    projdist = get_projdist(nspqm)
    
    z = quantile(actualdist, cdf(projdist, x))
        
    return cdf(targetdist, z) 
end

"""
    function projquantile(nspqm::ParametricQuantileMatchingModel, p::Real)

Compute the quantile function corresponding to the projection cdf.

See also [`projcdf`](@ref).
"""

function projquantile(nspqm::ParametricQuantileMatchingModel, p::Real)
    
    targetdist = get_targetdist(nspqm)
    actualdist = get_actualdist(nspqm)
    projdist = get_projdist(nspqm)
    
    x = cdf(actualdist, quantile(targetdist, p))
        
    return quantile(projdist, x)
    
end