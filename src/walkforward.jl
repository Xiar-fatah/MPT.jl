function _ffill(weights_df::AbstractDataFrame, date_df::AbstractDataFrame)::AbstractDataFrame
    """
    Description: 
    - Implementation of LOCF from: https://hongtaoh.com/en/2021/06/27/julia-ffill/
    Input:
    - weights_df: A dataframe of the weights over the limited period
    - date_df: A dataframe over the full period
    """
    res_df = leftjoin(date_df, weights_df, on = :Date)
    sort!(res_df, :Date)
    ffill(v) = v[accumulate(max, [i*!ismissing(v[i]) for i in 1:length(v)], init=1)]
    return DataFrame([ffill(res_df[!, c]) for c in names(res_df)], names(res_df))
end

function _realised_returns(returns_df::AbstractDataFrame, 
        ffill_df::AbstractDataFrame, 
        date_df::AbstractDataFrame)::AbstractDataFrame
    cols = ncol(returns_df)
    matrix_prod = sum(Matrix(returns_df[:, 2:cols]) .* Matrix(ffill_df[:, 2:cols]), dims = 2)
    temp_cumsum = cumsum(matrix_prod, dims = 1)
    cumsum_df = DataFrame(Realised = vec(temp_cumsum))
    return hcat(date_df, cumsum_df)
end

"""
    walk_forward
The *Arcsine distribution* has probability density function
"""
function walk_forward(returns::AbstractDataFrame, func, rebalancing::Int)
    """
    Input: 
    - Returns over full period
    - A function to calculate the weights
    - How often to rebalance the portfolio
    Output:
    """
    period, cols  = size(returns) # The length of the time series number of assets + date
    @assert rebalancing < period
    num_assets = cols - 1
    returns_assets = returns[:, 2:cols] # Filter out the dates
    index = 1 # Indexing in the while loop
    boolean = true
    # Create empty dataframe to populate with dates
    dates_df = select(returns, :Date)[1:rebalancing:end, :]
    # Preallocate the weights
    tot_weights = zeros(nrow(dates_df), num_assets) 
    while boolean
        #date = returns.Dates[rebalancing * index]
        if index * rebalancing > period
            returns_index = Matrix(returns_assets[1:end, 1:num_assets])
            calc_weights = equal_weights(returns_index)
            tot_weights[index, :] = calc_weights'
            boolean = false # End the while statement
        else
            returns_index = Matrix(returns_assets[1:index * rebalancing, 1:num_assets]) # index * rebalancing - (rebalancing-1)
            calc_weights = func(returns_index)
            tot_weights[index, :] = calc_weights'
        end
        index = index + 1
    end
    weights_df = DataFrame(tot_weights, names(returns)[2:end])
    weights_df = hcat(dates_df, weights_df)
    # Fill all the dates where there is no weights! 
    ffill_df = _ffill(weights_df, select(returns, :Date)) 
    # Calculate the total returns! 
    realised_returns = _realised_returns(returns, ffill_df, select(returns, :Date))
    # Plot the results
    _plot(realised_returns)
end