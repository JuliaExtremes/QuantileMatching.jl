module QuantileMatching

using Distributions, Interpolations, Optim

import Base: match, show

include("functions.jl")
include("AbstractQuantileMatchingModel.jl")


export

    # Variable type
    AbstractQuantileMatchingModel, 
    ParametricQuantileMatchingModel,
    NonStationary, Stationary,

    # Accessing struct features
    get_actualdist, get_targetdist, get_projdist,

    # Variable type
    EmpiricalQuantileMatchingModel,

    # Accessing struct features
    get_actualsample, get_targetsample, get_projsample, get_nbins, get_extrapolation,

    # Functions
    match, projcdf, projquantile,
    adjust_pwet, pwet, wet_threshold

end