@testset "data.jl" begin
    @testset "dataset(name)" begin
        # nonexistent file throws
        @test_throws ErrorException QuantileMatching.dataset("nonexistant")

        # observations loading
        @test_logs df = QuantileMatching.dataset("observations")
    end

end