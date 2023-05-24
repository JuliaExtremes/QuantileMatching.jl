
"""
    ecdf(y::Vector{<:Real})::Tuple{Vector{<:Real}, Vector{<:Real}}

Compute the empirical cumulative distribution function using the Gumbel formula.

## Details

The empirical quantiles are computed using the Gumbel plotting positions as
as recommended by [Makkonen (2006)](https://journals.ametsoc.org/jamc/article/45/2/334/12668/Plotting-Positions-in-Extreme-Value-Analysis).

## Example
```julia-repl
julia> (x, F̂) = Extremes.ecdf(y)
```

## Reference
Makkonen, L. (2006). Plotting positions in extreme value analysis. Journal of
Applied Meteorology and Climatology, 45(2), 334-340.
"""
function ecdf(y::Vector{<:Real})::Tuple{Vector{<:Real}, Vector{<:Real}}
    ys = sort(y)
    n = length(ys)
    p = collect(1:n)/(n+1)

    return ys, p
end


"""
    eqm(y::Vector{<:Real}, x::Vector{<:Real})

Return the corrected values of the actual sample `x` relative to the target sample `y` by empirical quantile matching.

## Details

The quantile matching is done in two steps. The first step is to adjust the proportion of wet days and the second step is to correct for non-zero values.
"""
function eqm(y::Vector{<:Real}, x::Vector{<:Real})
    
    # Adjust the non-zero frequency
    p = pwet(y)
    u = wet_threshold(x, p)
    x̃ = censor(x, u)
    
    # Extracting non-zero values
    y⁺ = filter(v -> v>0, y)
    x⁺ = filter(v -> v>0, x̃)
    
    # Define the empirical quantile matching model
    qmm = EmpiricalQuantileMatchingModel(y⁺, x⁺)

    # Quantile matching of non-zero values
    x̃⁺ = match(qmm, x⁺)

    # Replace the non-zero values in the frequency adjusted series.
    x̃[x̃ .> 0] = x̃⁺

    return x̃
    
end

"""
    pqm(pd::Type{<:ContinuousUnivariateDistribution}, y::AbstractVector{<:Real}, x::AbstractVector{<:Real})

Return the corrected values of the actual sample `x` relative to the target sample `y` by parametric quantile matching specified by `pd`.

## Details

The quantile matching is done in two steps. The first step is to adjust the proportion of wet days and the second step is to correct for 
non-zero values using the specified distribution.
"""
function pqm(pd::Type{<:ContinuousUnivariateDistribution}, y::AbstractVector{<:Real}, x::AbstractVector{<:Real})
    
    # Adjust the non-zero frequency
    p = pwet(y)
    u = wet_threshold(x, p)
    x̃ = censor(x, u)
    
    # Extracting non-zero values
    y⁺ = filter(v -> v>0, y)
    x⁺ = filter(v -> v>0, x̃)
    
    # Fit the parametric distributions on the target and actual samples
    fd_Y = fit(pd, y⁺)
    fd_X = fit(pd, x⁺)
    
    # Define the parametric quantile matching model
    qmm = ParametricQuantileMatchingModel(fd_Y, fd_X)

    # Quantile matching of non-zero values
    x̃⁺ = match(qmm, x⁺)

    # Replace the non-zero values in the frequency adjusted series. 
    x̃[x̃ .> 0] = x̃⁺

    return x̃
    
end


"""
    censor(y::Vector{<:Real}, u::Real ; fillvalue::Real=0)

Return the vector for which the value below `u` are filled with `fillvalue` and where `u` is substracted from the remaining values.

See also [`pwet`](@ref) and [`wet_threshold`](@ref).
"""
function censor(y::Vector{<:Real} where T<:Real, u::Real ; fillvalue::Real=zero(eltype(y)))
    
    if isfinite(u)
        z = y .- u
        z[z .≤ 0.] .= fillvalue
    elseif u == -Inf
        z = y
    else
        z = fill(fillvalue, length(y))
    end
    
    return z
    
end


"""
    pwet(y::Vector{<:Real}, threshold::Real=0.)

Compute the proportion of values of `y` greater than `threshold`.

See also [`censor`](@ref) and [`wet_threshold`](@ref).
"""
function pwet(y::Vector{<:Real}, threshold::Real=zero(eltype(y)))
    return count(y .> threshold) / length(y)
end 

"""
    wet_mean(y::Vector{<:Real}, threshold::Real=zero(eltype(y)))

Compute the mean of the elements of `y` exceeding the threshold `threshold`.

See also [`wet_quantile`](@ref) and [`wet_sum`](@ref).
"""
function wet_mean(y::Vector{<:Real}, threshold::Real=zero(eltype(y)))

    z = y[y .> threshold]

    return mean(z)
end


"""
    wet_quantile(y::Vector{<:Real}, p::Real; threshold::Real=zero(eltype(y)))

Compute the empirical quantile of order `p` of the values `y` exceeding the threshold `threshold`.

See also [`wet_mean`](@ref) and [`wet_sum`](@ref).
"""
function wet_quantile(y::Vector{<:Real}, p::Real, threshold::Real=zero(eltype(y)))

    z = y[y .> threshold]

    return quantile(z, p)
end


"""
    wet_sum(y::Vector{<:Real}, threshold::Real=zero(eltype(y)))

Compute the sum of the elements of `y` exceeding the threshold `threshold`.

See also [`wet_mean`](@ref) and [`wet_quantile`](@ref).
"""
function wet_sum(y::Vector{<:Real}, threshold::Real=zero(eltype(y)))
    
    z = y[y .> threshold]

    return sum(z)
end

"""
    wet_threshold(y::AbstractVector{<:Real}, p::Real)

Find the threshold for which the proportion of `y` values above this threshold is `p`.

See also [`pwet`](@ref) and [`censor`](@ref).
"""
function wet_threshold(y::AbstractVector{<:Real}, p::Real)
    
    @assert 0. ≤ p ≤ 1. "the proportion should be between 0 and 1."

    # Adding -Inf and +Inf at the ends of y
    z = [-Inf; y; Inf]
    
    q̂, p̂ = QuantileMatching.ecdf(z)
    
    _, ind = findmin((p̂ .- (1 .-p) ).^2)

    return q̂[ind]
    
end
