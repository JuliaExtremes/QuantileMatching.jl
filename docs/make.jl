using Documenter, QuantileMatching

CI = get(ENV, "CI", nothing) == "true"

makedocs(sitename = "QuantileMatching.jl",
    format = Documenter.HTML(
    prettyurls = CI,
    ),
    pages = [
       "description.md",
       "Example" =>["Stationary Quantile Matching" => "example/stationary.md"],
       "contributing.md",
       "index.md"]
)

# deploydocs(
#     repo = "github.com/JuliaExtremes/QuantileMatching.jl.git",
# )

if CI
    deploydocs(
    repo   = "github.com/JuliaExtremes/QuantileMatching.jl.git",
    devbranch = "dev",
    versions = ["stable" => "v^", "v#.#", "main"],
    push_preview = false,
    target = "build"
    )
end