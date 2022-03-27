module MPT

# Write your package code here.
# Mabye we should not have to build in plots?
# The user perhaps can plot themselves.
using Statistics, XLSX, DataFrames, JuMP, Dates
import Ipopt
export 
    walk_forward,
    equal_weights
    
include("import.jl")
include("portfolios.jl")
include("tools.jl")
include("walkforward.jl")

end
