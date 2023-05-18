
@testset "EmpiricalQuantileMatchingModel constructor" begin
    
    targetsample = [0.102010815529894, 0.07703698739948968, 0.7244081720416414, 0.7084891227459724, 0.4990629587314525]
    actualsample = [1.502901744984021, 2.2249912757196464, 2.6629189261859207, 2.046092118287037, 0.21713363327549823]
    projsample = [0.972352905203721, 6.939226027290031, 3.0783739221236877, 4.355620523932618, 0.2853185060397865]

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
    
    targetsample = [0.102010815529894, 0.07703698739948968, 0.7244081720416414, 0.7084891227459724, 0.4990629587314525]
    actualsample = [1.502901744984021, 2.2249912757196464, 2.6629189261859207, 2.046092118287037, 0.21713363327549823]
    projsample = [0.972352905203721, 6.939226027290031, 3.0783739221236877, 4.355620523932618, 0.2853185060397865]
    
    @testset "stationary" begin

        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
    @testset "non-stationary" begin

        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample, projsample)
        buffer = IOBuffer()
        @test_logs Base.show(buffer, qmm)
        
    end
    
end


@testset "match(::EmpiricalQuantileMatchingModel)" begin
    
    targetsample = sort([0.102010815529894, 0.07703698739948968, 0.7244081720416414, 0.7084891227459724, 0.4990629587314525])
    actualsample = sort([1.502901744984021, 2.2249912757196464, 2.6629189261859207, 2.046092118287037, 0.21713363327549823])
    projsample = sort([0.972352905203721, 6.939226027290031, 3.0783739221236877, 4.355620523932618, 0.2853185060397865])
    
    @testset "stationary" begin
        
        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample)
        
        @test match(qmm, [2.])[] ≈ 0.48401845735265503
        
    end
    
    @testset "non-stationary" begin
        
        qmm = EmpiricalQuantileMatchingModel(targetsample, actualsample, projsample)

        @test match(qmm, [2.])[] ≈ 0.8349460253709341
        
    end
    
end
    

