
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


# number of trains
N = length(df.Litra)


# vector of departure dates
Dd = df.AfgangDato

# vector of train number
Tn = df.Tognr

# vector of departure station
Ds = df.FraStation

# vector of arrival stations
As = df.TilStation

# Lbsnr vector
Ln = df.Lbsnr


# vector of binary values saying if a cleaning can happen at given station
Pc = (df.BinaryC)

# vector of stoptime on each stop
St =  (df.StopTime)

# Lbsnr vector
Ln = df.Lbsnr


# number of instances where trains are connected
Np = 0.0
p=1
# vector counting instances each train ride is connected with another
NZ = zeros(N)
# vector storing j-indexes when counted, to prevent recounting
Nj = zeros(N)
for i in 1:(N-2)
    if (i in Nj) == false
        for j in (i+1):(N-1)
            if Tn[i]==Tn[j] && Dd[i]==Dd[j] && Ds[i]==Ds[j] && St[i]==St[j]

                NZ[i] = NZ[i]+1
                Nj[p] = j
                global p = p+1

            end
        end
    end
end

# counting non-zeroes in Nz vector to see umber of connected trips
for i in 1:N
    if NZ[i] == 1
        global Np = Np + 1.0
    end
end
println(Np)
