
import XLSX
using JuMP
using GLPK

using DataFrames

# importerer excel ind som worksheet
#xf = XLSX.openxlsx("reviseddataTog1.xlsx")
#  sh = xf["Sheet1"]

# importerer excel ind som dataframe
df = DataFrame(XLSX.readtable("reviseddataAllData.xlsx","Sheet1"))

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

# vector of departure dates
Dd = df.AfgangDato

# vector of train number
Tn = df.Tognr

# vector of departure station
Ds = df.FraStation

# Lbsnr vector
Ln = df.Lbsnr

# time of Tr cleaning on ERF train in minutes
Tr = df.Tr
Or = df.Or

# Procentage of Or cleaning to Tr cleaning
q = zeros(N)
for i in 1:N
q[i] = Or[i]/Tr[i]
end

# vector of binary values saying if a cleaning can happen at given station
Pc = (df.BinaryC)

# vector of stoptime on each stop
St =  (df.StopTime)

# max cutoff of kilometers of dirtyness, in km
C = 1200.0

# big M notation
M = C

# Objective function
@objective(m, Min, sum(xt[i]*Tr[i] + Or[i]*xo[i] for i=1:N))

# constraints
@constraint(m, KD[1] >= km[1])
@constraint(m, KD[1] <= km[1])
@constraint(m, [i=1:N], xt[i] + xo[i] .<= Pc[i])
@constraint(m, [i=1:N], xt[i] * Tr[i] .<= St[i])
@constraint(m, [i=1:N], xo[i] * Or[i] .<= St[i])

@constraint(m, [i=2:N], zt[i] .<= xt[i-1] * M)
@constraint(m, [i=2:N], zo[i] .<= xo[i-1] * M)
@constraint(m, [i=2:N], zt[i] + zo[i] .<= KD[i-1])

@constraint(m, [i=2:N], zt[i] .>= KD[i-1] - (1 - xt[i-1]) * M)
@constraint(m, [i=2:N], zo[i] .>=  KD[i-1] - (1 - xo[i-1]) * M)

@constraint(m, [i=1:N], KD[i] .<= C)


# constraints deciding if two trains are connected
for i in 1:N
    for j in i+1:N
        if isequal(Tn[i],Tn[j]) && isequal(Dd[i],Dd[j]) && isequal(Ds[i],Ds[j])
            @constraint(m, xt[i] <= xt[j])
            @constraint(m, xt[i] >= xt[j])
            @constraint(m, xo[i] <= xt[j])
            @constraint(m, xo[i] >= xt[j])
        end
    end
end

# constraint making sure KD is reset when a new day train
for i in 2:N
    if Ln[i] != Ln[i-1]
        @constraint(m, KD[i] .<= km[i])
        @constraint(m, KD[i] .>= km[i])
    else
        @constraint(m, KD[i] .<= KD[i-1]+km[i]-zt[i]-q[i]*zo[i])
        @constraint(m, KD[i] .>= KD[i-1]+km[i]-zt[i]-q[i]*zo[i])
    end
end


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
