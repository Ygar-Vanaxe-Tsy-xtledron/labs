include("../../LabTools.jl")

using .LabTools, CSV, DataFrames

file = CSV.read("../data/335_G3.csv", DataFrame)

tabulate(file)
