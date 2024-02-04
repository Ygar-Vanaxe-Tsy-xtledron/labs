include("../LabTools.jl")

using .LabTools, CSV, DataFrames

file = CSV.read("csv", DataFrame)

tabulate(file)
