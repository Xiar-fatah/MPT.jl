# Portfolios

*Cholesky-variate distributions* are distributions whose variate forms are `CholeskyVariate`. This means each draw is a factorization of a positive-definite matrix of type `LinearAlgebra.Cholesky` (the object produced by the function `LinearAlgebra.cholesky` applied to a dense positive-definite matrix.)

## Equal Weights

```@docs
equal_weights
```
## Long Only Minimum Variance

```@docs
long_only_minimum_variance
```
## Most Diversified Portfolio

```@docs
mdp
```
## Random Weights

```@docs
random_weights
```

## Index

```@index
Pages = ["cholesky.md"]
```