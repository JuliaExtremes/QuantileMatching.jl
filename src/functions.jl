"""
    censor(y::Vector{<:Real}, u::Real ; fillvalue::Real=0)

Return the vector for which the value below `u` are filled with `fillvalue` and where `u` is substracted from the remaining values.

See also [`pwet`](@ref) and [`wet_threshold`](@ref).
"""
function censor(y::Vector{<:Real} where T<:Real, u::Real ; fillvalue::Real=zero(eltype(y)))
       
    z = y .- u
    
    z[z .≤ 0.] .= fillvalue
    
    return z
    
end


"""
    pwet(y::Vector{<:Real}, threshold::Real=0.)

Compute the proportion of values of `y` greater than `threshold`.

See also [`censor`](@ref) and [`wet_threshold`](@ref).
"""
function pwet(y::Vector{<:Real}, threshold::Real=0.)
    return count(y .> threshold) / length(y)
end 


"""
    wet_mean(y::Vector{<:Real}, p::Real; threshold::Real=one(eltype(y)))

Compute the mean of the exceedances above the `p`th quantile of the elements of `y` exceeding the threshold `threshold`.

See also [`wet_quantile`](@ref) and [`wet_sum`](@ref).
"""
function wet_mean(y::Vector{<:Real}, p::Real; threshold::Real=one(eltype(y)))
    
    u = wet_quantile(y, p, threshold = threshold)

    z = y[y .> u]

    return mean(z)
end

"""
    wet_quantile(y::Vector{<:Real}, p::Real; threshold:Real=1)

Compute the empirical quantile of order `p` of the values `y` exceeding the threshold `threshold`.

See also [`wet_mean`](@ref) and [`wet_sum`](@ref).
"""
function wet_quantile(y::Vector{<:Real}, p::Real; threshold::Real=one(eltype(y)))
    @assert zero(p)<p<one(p) "the quantile level should be between 0 and 1."

    z = y[y .> threshold]

    return quantile(z, p)
end


"""
    wet_sum(y::Vector{<:Real}, p::Real; threshold::Real=one(eltype(y)))

Compute the sum of the exceedances above the `p`th quantile of the elements of `y` exceeding the threshold `threshold`.

See also [`wet_mean`](@ref) and [`wet_quantile``](@ref).
"""
function wet_sum(y::Vector{<:Real}, p::Real; threshold::Real=one(eltype(y)))
    
    u = wet_quantile(y, p, threshold = threshold)

    z = y[y .> u]

    return sum(z)
end

"""
    wet_threshold(y::Vector{<:Real}, p::Real ; lowerbound::Real=0., upperbound::Real=5.)

Find the threshold for which the proportion of `y` values above this threshold is `p`.

See also [`pwet`](@ref) and [`censor`](@ref).
"""
function wet_threshold(y::Vector{<:Real}, p::Real ; lowerbound::Real=.9*minimum(y), upperbound::Real=maximum(y))
    
    @assert 0. ≤ p ≤ 1. "the proportion should be between 0 and 1."
    @assert lowerbound < upperbound "the upper bound should be larger than the lower bound."
    
    fobj(threshold::Real) = (pwet(y, threshold) - p)^2
    
    res = optimize(fobj, lowerbound, upperbound)

    u = Optim.minimizer(res)
    
    return u
    
end







