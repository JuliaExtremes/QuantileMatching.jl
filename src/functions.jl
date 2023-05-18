
"""
    adjust_pwet(y::Vector{<:Real}, p::Real ; fillvalue::Real=0.)

Return the vector for which the proportion of wet days is p.

## Details

The function finds the best threshold to obtain the desired proportion of wet days and then subtracts the threshold value. 
The values below the threshold are replaced with `fillvalue`.

See also [`pwet`](@ref) and [`wet_threshold`](@ref).
"""
function adjust_pwet(y::Vector{<:Real}, p::Real ; fillvalue::Real=0.)
    
    u = wet_threshold(y, p)
    
    z = y .- u
    
    z[z .≤ 0.] .= fillvalue
    
    return z
    
end

"""
    pwet(y::Vector{<:Real}, threshold::Real=0.)

Compute the proportion of values of `y` greater than `threshold`.

See also [`adjust_pwet`](@ref) and [`wet_threshold`](@ref).
"""
function pwet(y::Vector{<:Real}, threshold::Real=0.)
    return count(y .> threshold) / length(y)
end 

"""
    wet_threshold(y::Vector{<:Real}, p::Real ; lowerbound::Real=0., upperbound::Real=5.)

Find the threshold for which the proportion of `y` values above this threshold is `p`.

See also [`pwet`](@ref) and [`adjust_pwet`](@ref).
"""
function wet_threshold(y::Vector{<:Real}, p::Real ; lowerbound::Real=0., upperbound::Real=5.)
    
    @assert 0. ≤ p ≤ 1. "the proportion should be between 0 and 1."
    @assert lowerbound < upperbound "the upper bound should be larger than the lower bound."
    
    fobj(threshold::Real) = (pwet(y, threshold) - p)^2
    
    res = optimize(fobj, lowerbound, upperbound)

    u = Optim.minimizer(res)
    
    return u
    
end