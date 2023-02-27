
import XLSX
using JuMP
using GLPK

using DataFrames

# importerer excel ind som worksheet
#xf = XLSX.openxlsx("reviseddataTog1.xlsx")
#  sh = xf["Sheet1"]

# importerer excel ind som dataframe
df = DataFrame(XLSX.readtable("reviseddataTog1.xlsx","Sheet1"))

# julia kører rækker , søjler
##
# Mathematical model
m = Model(GLPK.Optimizer)

# number of trains
N = length(df.Litra)

# binary decision variables
@variable(m, xt[1:N], Bin)
@variable(m, xo[1:N], Bin)

# variable to linearize constraint
@variable(m, zt[1:N] >= 0 )
@variable(m, zo[1:N] >= 0 )

# initializing variable KD for "kilometers of dirtyness"
@variable(m, KD[1:N] >= 0)

# vector of kilometers between each stop
km =  (df.Km)

# time of Tr cleaning on ERF train in minutes
Tr = 80.0
Or = 20.0

# Procentage of Or cleaning to Tr cleaning
q = Or/Tr

# vector of binary values saying if a cleaning can happen at given station
Pc = (df.BinaryC)

# vector of stoptime on each stop
St =  (df.StopTime)

# max cutoff of kilometers of dirtyness, in km
C = 1500.0

# big M notation
M = C

# Objective function
@objective(m, Min, sum(xt[i]*Tr + Or*xo[i] for i=1:N))

# constraints
@constraint(m, KD[1] >= km[1])
@constraint(m, KD[1] <= km[1])
@constraint(m, [i=1:N], xt[i] + xo[i] .<= Pc[i])
@constraint(m, [i=1:N], xt[i] * Tr .<= St[i])
@constraint(m, [i=1:N], xo[i] * Or .<= St[i])

@constraint(m, [i=2:N], zt[i] .<= xt[i-1] * M)
@constraint(m, [i=2:N], zo[i] .<= xo[i-1] * M)
@constraint(m, [i=2:N], zt[i] + zo[i] .<= KD[i-1])

@constraint(m, [i=2:N], zt[i] .>= KD[i-1] - (1 - xt[i-1]) * M)
@constraint(m, [i=2:N], zo[i] .>=  KD[i-1] - (1 - xo[i-1]) * M)

@constraint(m, [i=2:N], KD[i] .>= KD[i-1] + km[i] - zt[i]-q*zo[i])
@constraint(m, [i=2:N], KD[i] .<= KD[i-1] + km[i] - zt[i]-q*zo[i])
@constraint(m, [i=1:N], KD[i] .<= C)

# Optimizing the model
optimize!(m)

# Printing the optimal solution
if termination_status(m) == MOI.OPTIMAL
    println("Objective value: ", JuMP.objective_value.(m))
    println("xt = ", JuMP.value.(xt))
    println("xo = ", JuMP.value.(xo))
else
    println("Optimize was not succesful. Return code: ", termination_status(m))
end
