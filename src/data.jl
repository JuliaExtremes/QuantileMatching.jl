
"""
    dataset(name::String)::DataFrame

Load the dataset associated with `name`.

Some datasets available:
 - `observations`: observed precipitations recorded at the Montréal-Trudeau International Airport;
 - `simulations`: simulated precipitations at the Montréal-Trudeau International Airport.


# Examples
```julia-repl
julia> RatingCurves.dataset("observations")
```
"""
function dataset(name::String)::DataFrame

    filename = joinpath(dirname(@__FILE__), "..", "data", string(name, ".csv"))
    if isfile(filename)
        # return DataFrame!(CSV.File(filename))
        return CSV.read(filename, DataFrame)
    end
    error("There is no dataset with the name '$name'")

end