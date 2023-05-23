
# Stationary quantile matching

This example shows the functionalities of *QuantileMatching.jl*. They are illustrated by post-processing the simulated precipitations of the *kda* member from the ClimEx ensemble ([Leduc *et al.*, 2019](https://journals.ametsoc.org/view/journals/apme/58/4/jamc-d-18-0021.1.xml)) with respect to the observed precipitations recorded at the Montréal-Trudeau International Airport. To avoid seasonality, we only consider precipitation from May to October and to avoid non-stationarity, we restrict the period from 1955 to 2010.

Before executing this tutorial, make sure to have installed the following packages:

- *CSV.jl* (for loading the data)
- *DataFrames.jl* (for using the DataFrame type)
- *ExtendedExtremes.jl* (for modeling the bulk and the tail of a distribution)
- *Extremes.jl* (for modeling the tail of a distribution)
- *Plots.jl* (for plotting)
- *QuantileMatching.jl*

and import them using the following command:
 ```@repl stationary
using CSV, DataFrames, Dates, ExtendedExtremes, Extremes, Plots, QuantileMatching
ENV["GKSwstype"] = "100" # hide
```

## Load the data

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

## Extract the non-zero precipitations

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

## Empirical quantile matching

Defining the model:

```@repl stationary
qmm = EmpiricalQuantileMatchingModel(y⁺, x⁺)
```

Quantile matching of the non-zero simulated precipitations:
```@example stationary
x̃⁺ = match(qmm, x⁺)

println("") # hide
```
Comparing the post-processed simulated precipitation distribution with the one for the observations

```@example stationary
Plots.default(size=(400,300)) # hide
QuantileMatching.qqplot(y⁺, x̃⁺)
```


Adding the zeros from the frequency adjusted values:
```@example stationary
x̃[x̃ .> 0] = x̃⁺

println("") # hide
```


