
@testset "functions" begin

    y = [0, 1, 2, 3, 4]

    @testset "censor" begin
        @test all(censor(y,1) .== [0, 0, 1, 2, 3])
    end

    @testset "pwet" begin
        @test pwet(y) ≈ 4/5
    end

    @testset "wet_mean" begin
        @test wet_mean(y, .5, threshold=0) ≈ 3.5
    end

    @testset "wet_quantile" begin
        @test wet_quantile(y, .5, threshold=0) ≈ 2.5
    end

    @testset "wet_quantile" begin
        @test wet_quantile(y, .5, threshold=0) ≈ 2.5
    end

    @testset "wet_sum" begin
        @test wet_sum(y, .5, threshold=0) ≈ 7
    end

    @testset "wet_threshold" begin
        @test 1. ≤ wet_threshold(y, 3/5) ≤ 2.
    end

end