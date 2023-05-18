module QuantileMatching

using Distributions, Interpolations, Optim

import Base: match, show

include("AbstractQuantileMatchingModel.jl")
include("functions.jl")


export

    # Abstract types
    AbstractQuantileMatchingModel, 
    NonStationary, Stationary,

    # Parametric type
    ParametricQuantileMatchingModel,

    # Accessing struct features
    get_actualdist, get_targetdist, get_projdist,

    # Parametric type
    EmpiricalQuantileMatchingModel,

    # Accessing struct features
    get_actualsample, get_targetsample, get_projsample, get_nbins, get_extrapolation,

    # Functions
    match, projcdf, projquantile,
    adjust_pwet, pwet, wet_threshold

end