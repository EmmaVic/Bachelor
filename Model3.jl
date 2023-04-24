import XLSX
using JuMP
using Gurobi
using CSV
using DataFrames

# importing excel in a dataframe
df = DataFrame(XLSX.readtable("reviseddataAllData.xlsx","Sheet1"))

# julia kører rækker , søjler
##
# Mathematical model
m = Model(Gurobi.Optimizer)

# time limit
set_time_limit_sec(m, 600)

# C-value vector
C = df.Cvalues

# big M notation
M = max(C)

# number of trains
N = length(df.Litra)

# binary decision variables
@variable(m, xt[1:N], Bin)
@variable(m, xo[1:N], Bin)

# variable to linearize constraint
@variable(m, zt[1:N] >= 0, upper_bound = M)
@variable(m, zo[1:N] >= 0, upper_bound = M)

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

# Objective function
@objective(m, Min, sum(xt[i]*Tr[i] + Or[i]*xo[i] for i=1:N))

# constraints
@constraint(m, KD[1] .>= km[1])
@constraint(m, KD[1] .<= km[1])
@constraint(m, [i=1:N], xt[i] + xo[i] .<= Pc[i])

@constraint(m, [i=2:N], zt[i] .<= xt[i-1] * M)
@constraint(m, [i=2:N], zo[i] .<= xo[i-1] * M)
@constraint(m, [i=2:N], zt[i] + zo[i] .<= KD[i-1])

@constraint(m, [i=2:N], zt[i] .>= KD[i-1] - (1 - xt[i-1]) * M)
@constraint(m, [i=2:N], zo[i] .>=  KD[i-1] - (1 - xo[i-1]) * M)

@constraint(m, [i=1:N],  xt[i] * Tr[i] +  xo[i] * Or[i] .<= St[i])

@constraint(m, [i=1:N], KD[i] .<= C[i])

# constraints deciding if two trains are connected
for i in 1:(N-1)
    for j in (i+1):N
        if Tn[i]==Tn[j] && Dd[i]==Dd[j] && Ds[i]==Ds[j] && St[i]==St[j]
            @constraint(m, xt[i]-xt[j]<=0)
            @constraint(m, xt[j]-xt[i]<=0)
            @constraint(m, xo[i]-xo[j]<=0)
            @constraint(m, xo[j]-xo[i]<=0)


        end
    end
end


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

for i in 1:N-2
    if Dd[i] != Dd[i+1] && Dd[i+1] != Dd[1]
        k=i+1
        while Dd[k] == Dd[k+1]  && k < N-1
            if  Pc[k] != 1 || St[k] < Tr[k]
                k = k + 1
            elseif Pc[k] == 1 && St[k] >= Tr[k]
                @constraint(m, xt[k] .>= 1)
                break
            else
                break
            end
        end
    end
end

# Optimizing the model
optimize!(m)

println( JuMP.objective_value.(m))

# wrighting the output out as an excel file
df[!, :Xt]=JuMP.value.(xt)
df[!, :Xo]=JuMP.value.(xo)
XLSX.writetable("Solmodel3.xlsx", df, overwrite=true, sheetname="sheet1", anchor_cell="A1")
