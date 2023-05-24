
# Stationary Quantile Matching

This example shows the functionalities of *QuantileMatching.jl*. They are illustrated by post-processing the simulated precipitations of the *kda* member from the ClimEx ensemble ([Leduc *et al.*, 2019](https://journals.ametsoc.org/view/journals/apme/58/4/jamc-d-18-0021.1.xml)) with respect to the observed precipitations recorded at the Montréal-Trudeau International Airport. To avoid seasonality, we only consider precipitation from May to October and to avoid non-stationarity, we restrict the period from 1955 to 2010.

The precipitation quantile matching procedure is performed in two steps. The first step is to match the empirical proportion of wet days between observations and simulations. The second step is to match the quantiles of simulated non-zero precipitation.


## Load required Julia packages

Before executing this tutorial, make sure to have installed the following packages:

- *CSV.jl* (for loading the data)
- *DataFrames.jl* (for using the DataFrame type)
- *Distributions.jl* (for using distribution objects)
- *ExtendedExtremes.jl* (for modeling the bulk and the tail of a distribution)
- *Extremes.jl* (for modeling the tail of a distribution)
- *Plots.jl* (for plotting)
- *QuantileMatching.jl*

and import them using the following command:
 ```@repl stationary
using CSV, DataFrames, Dates, Distributions
using ExtendedExtremes, Extremes, QuantileMatching
using Plots
ENV["GKSwstype"] = "100" # hide
```

# Data preparation

Loading the observed daily precipitations (in mm)
```@example stationary
# Load the data into a DataFrame
obs = QuantileMatching.dataset("observations")
dropmissing!(obs)

# Extract the values in a vector (including the zeros)
y = obs.Precipitation
 
println("") # hide
```

Plot the observed series for the year 1955:

```@example stationary
Plots.default(size=(400,300)) # hide
df = filter(row -> year(row.Date)==1955, obs)

Plots.plot(df.Date, df.Precipitation, label="", color=:grey, 
    xlabel="Date", ylabel="Observed precipitation (mm)")
```


Loading the simulated daily precipitations (in mm)
```@example stationary
# Load the data into a DataFrame
sim = QuantileMatching.dataset("simulations")
dropmissing!(sim)

# Extract the values in a vector (including the zeros)
x = sim.Precipitation

println("") # hide
```

Plot the observed series for the year 1955:

```@example stationary
Plots.default(size=(400,300)) # hide
df = filter(row -> year(row.Date)==1955, sim)

Plots.plot(df.Date, df.Precipitation, label="", color=:grey, 
    xlabel="Date", ylabel="Simulated precipitation (mm)")
```

## Frequency adjustment

Compute the proportion of wet days in the observations:

```@repl stationary
p = pwet(y)
```

Find the threshold for which the proportion of wet days in the simulations matches the proportion of wet days in the observations:

```@repl stationary
u = wet_threshold(x, p)
```

Censor the value below the threshold:
```@example stationary
x̃  = censor(x, u)

println("") # hide
```

### Extraction of non-zero precipitations

Extract the observed non-zero precipitations:

```@example stationary
y⁺ = filter(val -> val >0, y)

println("") # hide
```

Extract the frequency adjusted non-zero simulated precipitations:

```@example stationary
x⁺ = filter(val -> val >0, x̃)

println("") # hide
```

## Empirical Quantile Matching

### Model definition

Defining the model:

```@repl stationary
qmm = EmpiricalQuantileMatchingModel(y⁺, x⁺)
```

### Quantile matching

Quantile matching of the non-zero simulated precipitations:
```@example stationary
x̃⁺ = match(qmm, x⁺)

println("") # hide
```

### Comparison with the observations

Comparing the post-processed simulated precipitation distribution with the one for the observations

```@example stationary
Plots.default(size=(400,300)) # hide
QuantileMatching.qqplot(y⁺, x̃⁺)
```

### Fill in with dry days

Adding the zeros from the frequency adjusted values:
```@example stationary
x̃[x̃ .> 0] = x̃⁺

println("") # hide
```

## Gamma Quantile Matching

[Piani *et al.* (2010)](https://link.springer.com/article/10.1007/s00704-009-0134-9) propose to use the Gamma distribution to perform parametric quantile matching of precipitation. This parametric quantile matching method is referred to here as *Gamma Parametric Quantile Matching* (GPQM). 

### Model definition

Modelling the non-zero observed precipitations with the Gamma distribution:

```@repl stationary
fd_Y = fit(Gamma, y⁺)
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(y⁺, fd_Y, 0, 50), 
    QuantileMatching.qqplot(y⁺, fd_Y))
```

!!! note

    In this case, the Gamma distribution does not fit well the data. It is not surprising since precipitation is usually heavy-tailed but the Gamma distribution is light-tailed.

Modeling the non-zero simulated precipitations with the Gamma distribution:

```@repl stationary
fd_X = fit(Gamma, x⁺)
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(x⁺, fd_X, 0, 50), 
    QuantileMatching.qqplot(x⁺, fd_X))
```

Defining the model:

```@repl stationary
qmm = ParametricQuantileMatchingModel(fd_Y, fd_X)
```

### Quantile matching

Quantile matching of the non-zero simulated precipitations:
```@example stationary
x̃⁺ = match(qmm, x⁺)

println("") # hide
```

### Comparison with the observations

Comparing the post-processed simulated precipitation distribution with the one for the observations

```@example stationary
Plots.default(size=(400,300)) # hide
QuantileMatching.qqplot(y⁺, x̃⁺)
```

!!! note

    The corrected value distribution is not matching well the observation distribution. It is notably due to the fact that the Gamma distribution is light-tailed while precipitation is heavy-tailed.


## Gamma-Generalized Pareto Quantile Matching

[Gutjahr and Heinemann (2013)](https://link.springer.com/article/10.1007/s00704-013-0834-z) propose to use the Gamma distribution for the bulk and the generalized Pareto distribution for the right tail, *i.e* above the 95th quantile of non-zero precipitation. This parametric quantile matching method is referred to here as *Gamma-Generalized Pareto Quantile Matching* (GGPQM). 

### Model definition

Modelling the non-zero observed precipitations with the Gamma-Generalized Pareto distribution:

```@repl stationary
# Threshold selection for the tail
u = quantile(y⁺, .95)

# Fit the Gamma distribution for the bulk
f₁ = truncated(fit(Gamma, y⁺), 0, u)

# Fit the Generalized Pareto distribution for the right tail
fd = Extremes.gpfit( y⁺[y⁺.>u] .-u )
f₂ = GeneralizedPareto(u, exp(fd.θ̂[1]), fd.θ̂[2])

# Combining the two distributions
fd_Y = MixtureModel([f₁, f₂], [.95, .05])
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(y⁺, fd_Y, 0, 50), 
    QuantileMatching.qqplot(y⁺, fd_Y))
```

Modelling the non-zero simulated precipitations with the Gamma-Generalized Pareto distribution:

```@repl stationary
# Threshold selection for the tail
u = quantile(x⁺, .95)

# Fit the Gamma distribution for the bulk
f₁ = truncated(fit(Gamma, x⁺), 0, u)

# Fit the Generalized Pareto distribution for the right tail
fd = Extremes.gpfit( x⁺[x⁺.>u] .-u )
f₂ = GeneralizedPareto(u, exp(fd.θ̂[1]), fd.θ̂[2])

# Combining the two distributions
fd_X = MixtureModel([f₁, f₂], [.95, .05])
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(x⁺, fd_X, 0, 50), 
    QuantileMatching.qqplot(x⁺, fd_X))
```

Defining the model:

```@repl stationary
qmm = ParametricQuantileMatchingModel(fd_Y, fd_X)
```

### Quantile matching

Quantile matching of the non-zero simulated precipitations:
```@example stationary
x̃⁺ = match(qmm, x⁺)

println("") # hide
```

### Comparison with the observations

Comparing the post-processed simulated precipitation distribution with the one for the observations

```@example stationary
Plots.default(size=(400,300)) # hide
QuantileMatching.qqplot(y⁺, x̃⁺)
```

## Extended Generalized Pareto Quantile Matching

Gobeil *et al.* (2023, submitted) propose to use the extended Generalized Pareto distribution developed by [Gamet and Jalbert (2022)](https://onlinelibrary.wiley.com/doi/full/10.1002/env.2744) to perform parametric quantile matching of precipitation. This parametric quantile matching method is referred to here as *Extended Generalized Pareto Quantile Matching* (EGPQM). 

### Model definition

Modelling the non-zero observed precipitations with the extended Generalized Pareto distribution:

```@repl stationary
fd_Y = fit(ExtendedGeneralizedPareto{TBeta}, y⁺)
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(y⁺, fd_Y, 0, 50), 
    QuantileMatching.qqplot(y⁺, fd_Y))
```

Modelling the non-zero simulated precipitations with the extended Generalized Pareto distribution:

```@repl stationary
fd_X = fit(ExtendedGeneralizedPareto{TBeta}, x⁺)
```

Goodness-of-fit of the model:

```@example stationary
Plots.default(size=(800,300)) # hide
plot(QuantileMatching.histplot(x⁺, fd_X, 0, 50), 
    QuantileMatching.qqplot(x⁺, fd_X))
```

Defining the model:

```@repl stationary
qmm = ParametricQuantileMatchingModel(fd_Y, fd_X)
```

### Quantile matching

Quantile matching of the non-zero simulated precipitations:
```@example stationary
x̃⁺ = match(qmm, x⁺)

println("") # hide
```

### Comparison with the observations

Comparing the post-processed simulated precipitation distribution with the one for the observations

```@example stationary
Plots.default(size=(400,300)) # hide
QuantileMatching.qqplot(y⁺, x̃⁺)
```
