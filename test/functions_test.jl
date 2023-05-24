
@testset "functions" begin

    @testset "ecdf(y)" begin
        n = 10
        data = -1 * collect(1:n)

        y, p = QuantileMatching.ecdf(data)

        # y is length n and sorted
        @test length(y) == n
        @test issorted(y)

        # p is length n, sorted and between 0 and 1.
        @test length(p) == n
        @test issorted(p)
        @test p[1] >= 0 && p[end] <= 1

    end

    y = [0, 1, 2, 3, 4]

    @testset "censor" begin
        @test all(censor(y,1) .== [0, 0, 1, 2, 3])
        @test all(censor(y,-Inf) .== [0, 1, 2, 3, 4])
        @test all(censor(y,+Inf) .== [0, 0, 0, 0, 0])
    end

    @testset "pwet" begin
        @test pwet(y) ≈ 4/5
    end

    @testset "wet_mean" begin
        @test wet_mean(y, 0) ≈ 2.5
    end

    @testset "wet_quantile" begin
        @test wet_quantile(y, .5, 0) ≈ 2.5
    end

    @testset "wet_sum" begin
        @test wet_sum(y, 0) ≈ 10
    end

    @testset "wet_threshold" begin
        @test wet_threshold(y, 3/5) ≈ 1.
        @test wet_threshold(y, 0) ≈ Inf
        @test wet_threshold(y, 1) ≈ -Inf
    end

end