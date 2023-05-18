
@testset "EmpiricalQuantileMatchingModel constructor" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)

    targetsample = rand(targetdist, 5)
    actualsample = rand(actualdist, 5)
    projsample = rand(projdist, 5)

    @testset "stationary" begin

        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample)

        @test typeof(qmm) == EmpiricalQuantileMatchingModel{Stationary}
        @test all(get_targetsample(qmm) .≈ sort(targetsample))
        @test all(get_actualsample(qmm) .≈ sort(actualsample))
        @test get_nbins(qmm) == length(actualsample)
        @test get_extrapolation(qmm) == Interpolations.Flat()
    end

    @testset "non-stationary" begin

        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample, projsample)

        @test typeof(qmm) == EmpiricalQuantileMatchingModel{NonStationary}
        @test all(get_targetsample(qmm) .≈ sort(targetsample))
        @test all(get_actualsample(qmm) .≈ sort(actualsample))
        @test all(get_projsample(qmm) .≈ sort(projsample))
        @test get_nbins(qmm) == length(actualsample)
        @test get_extrapolation(qmm) == Interpolations.Flat()
    end
    
end

@testset "Base.show(io, obj)" begin
    
    targetdist = Exponential(.5)
    actualdist = Exponential(2)
    projdist = Exponential(3)
    
    @testset "stationary" begin

        qmm = EmpericalQuantileMatchingModel(targetdist, actualdist)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
    @testset "non-stationary" begin

        qmm = EmpericalQuantileMatchingModel(targetdist, actualdist, projdist)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
end