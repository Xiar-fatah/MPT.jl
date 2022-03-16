function calculate_prices(path::String)
    xf = XLSX.readxlsx("DATA.xlsx")
    sheetnames = XLSX.sheetnames(xf)
    num_sheets = length(sheetnames)
    store_dfs = []
    for i = 2:num_sheets # 2 for the main sheet
        df = DataFrame(XLSX.readtable("DATA.xlsx", sheetnames[i])...)
        name = XLSX.sheetnames(xf)[i]
        rename!(df,:Close => name)
        df = df[:, ["Date", name]]
        push!(store_dfs, df)
    end
    prices = innerjoin(store_dfs[1], store_dfs[2], on = :Date)
    for i = 3:num_sheets-1
        prices = innerjoin(prices, store_dfs[i], on = :Date)
    end
    return prices
end
function calculate_returns(prices::AbstractDataFrame)
    dates = prices[2:end, 1]
    # Make the dates a single dataframe
    dates_df = DataFrame("Dates" => dates) 
    names_assets = names(prices)[2:end]
    num_assets = length(names_assets) - 1 
    prices = Matrix(select(prices, Not(:Date))) 
    returns = diff(log.(prices), dims = 1)
    # Create a dataframe for the returns
    returns_df = DataFrame(returns, names_assets)
    # Concatenate dates and returns
    res_df = hcat(dates_df, returns_df)
    # Correct the date column with the correct type
    rename!(res_df,:Dates => :Date)
    res_df.Date = Dates.Date.(string.(res_df.Date), "yyyy-mm-dd")
    return res_df
end
