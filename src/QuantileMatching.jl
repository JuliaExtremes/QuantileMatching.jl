module QuantileMatching

using Distributions, Interpolations, Optim

import Base: match, show


include("AbstractQuantileMatchingModel.jl")


export

    # Variable type
    AbstractQuantileMatchingModel, 
    ParametricQuantileMatchingModel,
    NonStationary, Stationary,

    # Accessing struct features
    get_actualdist, get_targetdist, get_projdist,

    # Functions
    match, projcdf, projquantile

end