
@testset "functions" begin

    y = [0, 1, 2, 3, 4]

    @testset "censor" begin
        @test all(censor(y,1) .== [0, 0, 1, 2, 3])
    end

    @testset "pwet" begin
        @test pwet(y) ≈ 4/5
    end

    @testset "wet_threshold" begin
        @test 1. ≤ wet_threshold(y, 3/5) ≤ 2.
    end

end