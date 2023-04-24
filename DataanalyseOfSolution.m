% Dataanalysis of own data
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 13/03/2023
%% 

solution = Solmodel3;

% Antal rengøringer i alt
index = [];
j = 1; 
totalAntal = 0;

for i = 1:height(solution(:,1))
    if solution{i,16} == 1 || solution{i,17} == 1
        totalAntal = totalAntal + 1;
        index(j) = i;
        j = j+1;
    end
end

% Antal OR 
ORantal = 0;

for i = 1:height(solution(:,1))
    if solution{i,17} == 1
        ORantal = ORantal + 1;
    end
end

% Antal TR 
TRantal = 0;

for i = 1:height(solution(:,1))
    if solution{i,16} == 1
        TRantal = TRantal + 1;
    end
end

%% min, max og mean mellem rengøringer
KmBetween = [];
k = 1; 
for i = 1:length(index)-1
    if solution{index(i),1} == solution{index(i+1),1}
        KmBetween(i) = sum(solution{index(i)+1:index(i+1),10});
        k = k+1;
    end
end

max(nonzeros(KmBetween))
min(nonzeros(KmBetween))
mean(nonzeros(KmBetween))

[M,I] = max(KmBetween);