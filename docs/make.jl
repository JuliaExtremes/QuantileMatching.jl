using Documenter, QuantileMatching

CI = get(ENV, "CI", nothing) == "true"

makedocs(sitename = "QuantileMatching.jl",
    format = Documenter.HTML(
    prettyurls = CI,
    ),
    pages = [
       "description.md",
       "example.md",
       "contributing.md",
       "index.md"]
)

deploydocs(
    repo = "github.com/JuliaExtremes/QuantileMatching.jl.git",
)