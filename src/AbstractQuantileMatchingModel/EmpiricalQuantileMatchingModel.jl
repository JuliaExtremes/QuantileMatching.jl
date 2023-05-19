"""
    EmpiricalQuantileMatchingModel{T}

Structure containing the different distributions for performing empirical quantile matching.

## Details

- `targetsample`: target sample (local-scale sample for the calibration period)
- `actualsample`: actual sample (large-scale sample for the calibration period)
- `projsample`: projected sample (large-scale sample for the projected period)
- `nbins`: number of bins used to compute the transfert function
- `extrapolation`: extrapolation method when large-scale values lies outside the range of the local-scale values. 
 It should be an `Interpolations.BoundaryCondition` type like for example `Interpolations.Flat()` and `Interpolations.Line()`.

If `extrapolation = Interpolations.Flat()`, there is no extrapolation of the local-scale quantile. The post-processed value is either the minimum or the maximum of the local-scale values. 

If `extrapolation = Interpolations.Line()`, post-processed quantiles beyond the range of the local-scale values are extrapolated using a linear model. 

If the `projsample` is not provided, the quantile matching model is assumed to be stationary and the actual distribution is post-processed.

See also [`ParametricQuantileMatchingModel`](@ref)
"""
struct EmpiricalQuantileMatchingModel{T} <: AbstractQuantileMatchingModel
    targetsample::Vector{<:Real}
    actualsample::Vector{<:Real}
    projsample::Vector{<:Real}
    nbins::Int64
    extrapolation::Interpolations.BoundaryCondition
end 

function EmpiricalQuantileMatchingModel(targetsample::Vector{<:Real}, actualsample::Vector{<:Real};
        nbins::Int=length(actualsample),
        extrapolation::Interpolations.BoundaryCondition=Interpolations.Flat())
    ts = Float64.(sort(targetsample))
    as = Float64.(sort(actualsample))
    return EmpiricalQuantileMatchingModel{Stationary}(ts, as, as, nbins, extrapolation)
end

function EmpiricalQuantileMatchingModel(targetsample::Vector{<:Real}, actualsample::Vector{<:Real}, projsample::Vector{<:Real};
            nbins::Int=length(actualsample),
            extrapolation::Interpolations.BoundaryCondition=Interpolations.Flat())
    ts = Float64.(sort(targetsample))
    as = Float64.(sort(actualsample))
    ps = Float64.(sort(projsample))
    return EmpiricalQuantileMatchingModel{NonStationary}(ts, as, ps, nbins, extrapolation)
end

function get_actualsample(qmm::EmpiricalQuantileMatchingModel)
    return qmm.actualsample
end

function get_targetsample(qmm::EmpiricalQuantileMatchingModel)
    return qmm.targetsample
end

function get_projsample(qmm::EmpiricalQuantileMatchingModel)
    return qmm.projsample
end

function get_nbins(qmm::EmpiricalQuantileMatchingModel)
    return qmm.nbins
end

function get_extrapolation(qmm::EmpiricalQuantileMatchingModel)
    return qmm.extrapolation
end

function Base.show(io::IO, obj::EmpiricalQuantileMatchingModel{T} where T)
    showEmpiricalQuantileMatchingModel(io, obj)
end

function showEmpiricalQuantileMatchingModel(io::IO, obj::EmpiricalQuantileMatchingModel{Stationary}; prefix::String = "")
    println(io, prefix, "EmpiricalQuantileMatchingModel{Stationary}")
    
    println(io, prefix, "    ", "targetsample::Vector{Float64}[",
        length(get_targetsample(obj)), "] = [",
        round(get_targetsample(obj)[1], digits=4),",...,", round(get_targetsample(obj)[end], digits=4), "]")
    
    println(io, prefix, "    ", "actualsample::Vector{Float64}[",
        length(get_actualsample(obj)), "] = [",
        round(get_actualsample(obj)[1], digits=4),",...,", round(get_actualsample(obj)[end], digits=4), "]")
    
    println(io, prefix, "    ", "nbins: ",get_nbins(obj))
        
    println(io, prefix, "    ", "extrapolation: ",get_extrapolation(obj))
end

function showEmpiricalQuantileMatchingModel(io::IO, obj::EmpiricalQuantileMatchingModel{NonStationary}; prefix::String = "")
    println(io, prefix, "EmpiricalQuantileMatchingModel{NonStationary}")
    
    println(io, prefix, "    ", "targetsample::Vector{Float64}[",
        length(get_targetsample(obj)), "] = [",
        round(get_targetsample(obj)[1], digits=4),",...,", round(get_targetsample(obj)[end], digits=4), "]")
    
    println(io, prefix, "    ", "actualsample::Vector{Float64}[",
        length(get_actualsample(obj)), "] = [",
        round(get_actualsample(obj)[1], digits=4),",...,", round(get_actualsample(obj)[end], digits=4), "]")
    
    println(io, prefix, "    ", "projsample::Vector{Float64}[",
        length(get_projsample(obj)), "] = [",
        round(get_projsample(obj)[1], digits=4),",...,", round(get_projsample(obj)[end], digits=4), "]")
        
    println(io, prefix, "    ", "nbins: ",get_nbins(obj))
        
    println(io, prefix, "    ", "extrapolation: ",get_extrapolation(obj))
end

function match(eqmm::EmpiricalQuantileMatchingModel{Stationary}, x::Vector{<:Real})
    
    nbins = get_nbins(eqmm)
    
    targetsample = get_targetsample(eqmm)
    actualsample = get_actualsample(eqmm)
    
    p = (1:nbins)/nbins
    
    q_target = quantile(targetsample, p, sorted=true)
    q_actual = quantile(actualsample, p, sorted=true)
    
    itp = interpolate((q_actual,), Interpolations.deduplicate_knots!(q_target), Gridded(Interpolations.Linear()))
    itp = extrapolate(itp, get_extrapolation(eqmm))
    
    x̃ = itp(x)
end

function match(eqmm::EmpiricalQuantileMatchingModel{NonStationary}, x::Vector{<:Real})
    
    nbins = get_nbins(eqmm)
    
    targetsample = get_targetsample(eqmm)
    actualsample = get_actualsample(eqmm)
    projsample = get_projsample(eqmm)
    
    z = match(EmpiricalQuantileMatchingModel(targetsample, projsample), x)
    x̃ = match(EmpiricalQuantileMatchingModel(projsample, actualsample), z)
    
    return x̃
    
end