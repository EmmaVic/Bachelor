
import XLSX
using JuMP
using Gurobi
using CSV
using DataFrames

# importerer excel ind som worksheet
#xf = XLSX.openxlsx("reviseddataTog1.xlsx")
#  sh = xf["Sheet1"]

# importerer excel ind som dataframe
df = DataFrame(XLSX.readtable("reviseddataAllData.xlsx","Sheet1"))

# julia kører rækker , søjler
##
# Mathematical model
m = Model(Gurobi.Optimizer)

# number of trains
N = length(df.Litra)

# binary decision variables
@variable(m, xt[1:N], Bin)
@variable(m, xo[1:N], Bin)

# variable to linearize constraint
@variable(m, zt[1:N] .>= 0 )
@variable(m, zo[1:N] .>= 0 )

# initializing variable KD for "kilometers of dirtyness"
@variable(m, KD[1:N] .>= 0)

# vector of kilometers between each stop
km =  (df.Km)

# time of Tr and Or cleaning in minutes
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

# Lbsnr vector
Ln = df.Lbsnr

# max cutoff of kilometers of dirtyness, in km
C = 1638.0

# big M notation
M = C

# Objective function
@objective(m, Min, sum(xt[i]*Tr[i] + Or[i]*xo[i] for i=1:N))


# constraints
@constraint(m, KD[1] .>= km[1])
@constraint(m, KD[1] .<= km[1])
@constraint(m, [i=1:N], xt[i] + xo[i] .<= Pc[i])
@constraint(m, [i=1:N], xt[i] * Tr[i] +  xo[i] * Or[i] .<= St[i])

@constraint(m, [i=2:N], zt[i] .<= xt[i-1] * M)
@constraint(m, [i=2:N], zo[i] .<= xo[i-1] * M)
@constraint(m, [i=2:N], zt[i] + zo[i] .<= KD[i-1])

@constraint(m, [i=2:N], zt[i] .>= KD[i-1] - (1 - xt[i-1]) * M)
@constraint(m, [i=2:N], zo[i] .>=  KD[i-1] - (1 - xo[i-1]) * M)

@constraint(m, [i=1:N], KD[i] .<= C)

# constraint making sure KD is reset when a new train
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
else
    println("Optimize was not succesful. Return code: ", termination_status(m))
end



## wrighting the output out as an excel file
df[!, :Xt]=JuMP.value.(xt)
df[!, :Xo]=JuMP.value.(xo)
XLSX.writetable("Solmodel1.xlsx", df, overwrite=true, sheetname="sheet1", anchor_cell="A1")
