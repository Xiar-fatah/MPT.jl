function equal_weights(returns::AbstractMatrix)::AbstractVector
    """
    Input: Returns over a specific period.
    Output: The weights of equal weights portfolio allocation.
    """
    num_assets = size(returns)[2] 
    weights = fill(1/num_assets, (num_assets))
    return weights
end

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

function long_only_minimum_variance(returns::AbstractMatrix)::AbstractVector
    cov_matrix = cov(returns)
    portfolio = Model(Ipopt.Optimizer)
    num_assets = size(cov_matrix)[1]
    set_silent(portfolio) # Suppress the output
    @variable(portfolio, x[1:num_assets] >= 0)
    @objective(portfolio, Min, x' * cov_matrix * x)
    @constraint(portfolio, sum(x[i] for i = 1:num_assets) == 1)
    optimize!(portfolio)
    weights = value.(x)
    return weights
end
function inverse_variance(returns::AbstractMatrix)::AbstractVector
    return 0
end
function inverse_volatility(returns::AbstractMatrix)::AbstractVector
    return 0
end