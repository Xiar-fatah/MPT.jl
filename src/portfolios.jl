"""
    equal_weights(returns::AbstractMatrix)::AbstractVector
```math
    w_i = 1/N \\quad  i \\in [1, \\hdots, N] 
```
External links
* DeMiguel, V., Garlappi, L., & Uppal, R. (2009). 
  Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy?.
  The review of Financial studies, 22(5), 1915-1953.
  doi: [10.1093/hhm075](https://doi.org/10.1093/rfs/hhm075)
"""
function equal_weights(returns::AbstractMatrix)::AbstractVector
    """
    Input: Returns over a specific period.
    Output: The weights of equal weights portfolio allocation.
    """
    num_assets = size(returns)[2] 
    weights = fill(1/num_assets, (num_assets))
    return weights
end

"""
long_only_minimum_variance
    ```math
    \\textrm{minimize}_{\\frac{\\vec{w}^T \\vec{\\sigma}}{\\sqrt{\\vec{w}^T \\Sigma \\vec{w}}}, \\\\
    \\textrm{subject to} \\quad \\vec{1}^T \\vec{w} = 1 \\quad \\vec{w} \\geq 0.
```
External links
* DeMiguel, V., Garlappi, L., & Uppal, R. (2009). 
  Optimal versus naive diversification: How inefficient is the 1/N portfolio strategy?.
  The review of Financial studies, 22(5), 1915-1953.
  doi: [10.1093/hhm075](https://doi.org/10.1093/rfs/hhm075)
"""
function long_only_minimum_variance(returns::AbstractMatrix)::AbstractVector
    cov_matrix = cov(returns)
    portfolio = Model(Ipopt.Optimizer)
    set_silent(portfolio) # Suppress the output
    num_assets = size(cov_matrix)[1]
    @variable(portfolio, x[1:num_assets] >= 0)
    @objective(portfolio, Min, x' * cov_matrix * x)
    @constraint(portfolio, sum(x[i] for i = 1:num_assets) == 1)
    optimize!(portfolio)
    weights = value.(x)
    return weights
end
"""
    random_weights
```math
f(x) = \\frac{1}{\\pi \\sqrt{(x - a) (b - x)}}, \\quad x \\in [a, b]
```
"""
function random_weights(returns::AbstractMatrix)::AbstractVector
    """
    Input: Returns over a specific period.
    Output: Randomized weights of a portfolio.
    """
    num_assets = size(returns)[2] 
    weights = rand(num_assets)
    norm = sum(weights)
    weights = weights ./ norm
    return weights
end
"""
    mdp
```math
    \\textrm{maximize}_{\\vec{w}} \\quad  \\frac{\\vec{w}^T \\vec{\\sigma}}{\\sqrt{\\vec{w}^T \\Sigma \\vec{w}}}, \\\\
    \\textrm{subject to} \\quad \\vec{1}^T \\vec{w} = 1.
```
External links
* Choueifaty, Y., Froidure, T., & Reynier, J. (2013). 
  Properties of the most diversified portfolio.
  Journal of investment strategies, 2(2), 49-70.
  doi: [10.2139/ssrn.1895459](https://dx.doi.org/10.2139/ssrn.1895459)
"""
function mdp(returns::AbstractMatrix)::AbstractVector
    cov_matrix = cov(returns)
    var_vector = var(returns)
    portfolio = Model(Ipopt.Optimizer)
    set_silent(portfolio) # Suppress the output
    num_assets = size(cov_matrix)[1]
    @variable(portfolio, x[1:num_assets] >= 0)
    @objective(portfolio, Min, 0.5 * x' * cov_matrix * x)
    @constraint(portfolio, sum(x[i] * var_vector[i] for i = 1:num_assets) == 1)
    optimize!(portfolio)
    weights = value.(x)
    weights = weights ./ sum(weights)
    return weights
end

function inverse_variance(returns::AbstractMatrix)::AbstractVector
    return 0
end
function inverse_volatility(returns::AbstractMatrix)::AbstractVector
    return 0
end
