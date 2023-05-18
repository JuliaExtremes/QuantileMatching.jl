@testset "ParametricQuantileMatchingModel constructor" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    @testset "stationary" begin

        qmm = ParametricQuantileMatchingModel(targetdist, actualdist)

        @test typeof(qmm) == ParametricQuantileMatchingModel{Stationary}
        @test get_targetdist(qmm) == targetdist
        @test get_actualdist(qmm) == actualdist
        @test get_projdist(qmm) == actualdist
    end
    
    @testset "non-stationary" begin
       
        qmm = ParametricQuantileMatchingModel(targetdist, actualdist, projdist)

        @test typeof(qmm) == ParametricQuantileMatchingModel{NonStationary}
        @test get_targetdist(qmm) == targetdist
        @test get_actualdist(qmm) == actualdist
        @test get_projdist(qmm) == projdist
    end
    
end

@testset "Base.show(io, obj)" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    @testset "stationary" begin

        qmm = ParametricQuantileMatchingModel(targetdist, actualdist)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
    @testset "non-stationary" begin

        qmm = ParametricQuantileMatchingModel(targetdist, actualdist, projdist)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
end

@testset "match(::ParametricQuantileMatchingModel)" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    @testset "stationary" begin
        
        qmm = ParametricQuantileMatchingModel(targetdist, actualdist)
        
        x = [4]
        x̃ = rate(actualdist)/rate(targetdist)*[4]
        
        @test match(qmm, x) ≈ x̃
        
    end
    
    @testset "non-stationary" begin
        
        qmm = ParametricQuantileMatchingModel(targetdist, actualdist, projdist)
        
        λ = rate(targetdist)*rate(projdist)/rate(actualdist)
        
        x = [4.]
        x̃ = quantile(Exponential(1/λ), cdf(projdist, x))
        
        @test match(qmm, x) ≈ x̃
        
    end
    
end

@testset "projcdf(::ParametricQuantileMatchingModel)" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    qmm = ParametricQuantileMatchingModel(targetdist, actualdist, projdist)
    
    λ = rate(targetdist)*rate(projdist)/rate(actualdist)
        
    x = 4
    
    @test projcdf(qmm, x) ≈ cdf(Exponential(1/λ), x)
    
end

@testset "projquantile(::ParametricQuantileMatchingModel)" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    qmm = ParametricQuantileMatchingModel(targetdist, actualdist, projdist)
    
    λ = rate(targetdist)*rate(projdist)/rate(actualdist)
        
    p = .75
    
    @test projquantile(qmm, p) ≈ quantile(Exponential(1/λ), p)
    
end