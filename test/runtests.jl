using QuantileMatching

using Distributions, Test

@testset "QuantileMatching.jl" begin
    
    include("AbstractQuantileMatchingModel/ParametricQuantileMatchingModel_test.jl")

end
