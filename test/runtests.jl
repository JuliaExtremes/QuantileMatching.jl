using QuantileMatching

using Distributions, Interpolations, Test

@testset "QuantileMatching.jl" begin
    
    include("AbstractQuantileMatchingModel_test.jl")
    include("functions_test.jl")

end
