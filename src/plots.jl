
# TODO: move into another library

function histplot(y::Vector{Float64}, pd::Distribution, lbound::Real, ubound::Real)
    
    histplot(y, pd)
    Plots.plot!(xlim = (lbound, ubound))
    
end


function histplot(y::Vector{Float64}, pd::Distribution)
   
    fig = Plots.histogram(y, normed=true, alpha=0.6, label="", c=:grey, legend=false)
    xl = xlims(fig)
    Plots.plot!(x -> pdf.(pd, x), xl[1], xl[2], label="", c=:black, linewidth = 1.5)
    
end

function returnlevelplot(y::Vector{Float64}, pd::Distribution)
    
    n = length(y)
    q = sort(y)
 
    p = (1:n) ./ (n+1)
    
    t = 1 ./ (1 .- p)
    
    Plots.plot(t, q, xaxis=:log10, seriestype=:scatter, markerstrokewidth=0, markercolor=:grey, label="")
    Plots.plot!(t, quantile.(pd, p), label="", ls=:dash, color=:black)
    
end

function qqplot(y::Vector{Float64}, pd::Distribution)
    
    q̂, p = QuantileMatching.ecdf(y)
    
    Plots.plot(q, q̂, seriestype = :scatter, markerstrokewidth=0, markercolor=:grey, label="",
        xlabel="empirical quantile", ylabel="estimated quantile")
    Plots.plot!(q[[1, end]], q[[1, end]], label="", ls=:dash, color=:black)
end

function qqplot(y::Vector{<:Real}, ŷ::Vector{<:Real})
    
    q, p = QuantileMatching.ecdf(y)
    q̂ = quantile(ŷ, p)
    
    Plots.plot(q, q̂, seriestype = :scatter, markerstrokewidth=0, markercolor=:grey, label="",
        xlabel="observed quantile", ylabel="simulated quantile")
    Plots.plot!(q[[1, end]], q[[1, end]], label="", ls=:dash, color=:black)
    
end


function probplot(y::Vector{Float64}, pd::Distribution)
    
    q, p = QuantileMatching.ecdf(y)
    p̂ = cdf.(pd, q)
    
    Plots.plot(p, p̂, seriestype = :scatter, markerstrokewidth=0, markercolor=:grey, label="",
        xlabel="empirical probability", ylabel="estimated probability")
    Plots.plot!(p[[1, end]], p[[1, end]], label="", ls=:dash, color=:black)
end