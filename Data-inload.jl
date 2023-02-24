import XLSX
using JuMP
using GLPK

using DataFrames

# importerer excel ind som worksheet
#xf = XLSX.openxlsx("reviseddataTog1.xlsx")
#  sh = xf["Sheet1"]

# importerer excel ind som dataframe
df = DataFrame(XLSX.readtable("datatog1.xlsx","Sheet1"))

# julia kører rækker , søjler
##
# Mathematical model
m = Model(GLPK.Optimizer)

# number of stations
N = length(df.Litra)
# time of Tr cleaning on ERF train in minutes
Tr = 80.0
Or = 20.0

# vector of binary values saying if a cleaning can happen at given station
Pc = Array{Float64}(df.BinaryC)
# vector of total kilometers
b =  Array{Float64}(df.TotalKm)
# vector of kilometers between each stop
km =  Array{Float64}(df.Km)
# vector of stoptime on each stop
St =  Array{Float64}(df.Stoptime)

# max cutoff of kilometers of dirtyness, in km
C = 1000.0
M = 5000.0

# variables
@variable(m, xt[i=1:N], Bin)
@variable(m, xo[i=1:N], Bin)
@variable(m, zt[i=1:N] >= 0)
@variable(m, zo[i=1:N] >= 0)
@variable(m, KD[i=1:N] >= 0)


# Objective function
@objective(m, Min, sum(xt[i]*Tr+xo[i]*Or for i=1:N))

# constraints
@constraint(m, KD[1] >= km[1])
@constraint(m, [i=1:N], xt[i] + xo[i] <= Pc[i])
@constraint(m, [i=1:N], xt[i] * Tr <= St[i])
@constraint(m, [i=1:N], xo[i] * Or <= St[i])


@constraint(m, [i=2:N], KD[i] >= KD[i-1] + km[i] - zt[i] - 1/2*zo[i])

@constraint(m, [i=2:N], zt[i] <= xt[i-1] * M)
@constraint(m, [i=2:N], zt[i] <= KD[i-1])
@constraint(m, [i=2:N], zt[i] >= KD[i-1] - (1 - xt[i-1]) * M)

@constraint(m, [i=2:N], zo[i] <= xo[i-1] * M)
@constraint(m, [i=2:N], zo[i] <= KD[i-1])
@constraint(m, [i=2:N], zo[i] >= KD[i-1] - (1 - xo[i-1]) * M)

@constraint(m, [i=1:N], KD[i] <= C)

optimize!(m)


if termination_status(m) == MOI.OPTIMAL
    println("Objective value: ", JuMP.objective_value.(m))
    println("xt = ", JuMP.value.(xt))
    println("xo = ", JuMP.value.(xo))
else
    println("Optimize was not succesful. Return code: ", termination_status(m))
end
