% Dataanalysis of own data
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 13/03/2023
%% 

solution = Solmodel1;

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
%%
Litra1 = solution(1:1803,:);
Litra2 = solution(1804:2551,:);
Litra3 = solution(2552:6758,:);
Litra4 = solution(6759:7859,:);
Litra5 = solution(7860:8922,:);
Litra6 = solution(8923:11575,:);
Litra7 = solution(11576:end,:);
%%

Litra = solution;

% Antal rengøringer i alt
totalAntal = 0;
ORantal = 0;
TRantal = 0;

for i = 1:height(Litra(:,1))
    if Litra{i,16} == 1 || Litra{i,17} == 1
        totalAntal = totalAntal + 1;
        if Litra{i,17} == 1
            ORantal = ORantal + 1;
        elseif Litra{i,16} == 1
            TRantal = TRantal + 1;
        end
    end
end

%% 
j = 1; 
vector = [];
kmCount = 0;

Litra = Litra7;

for i = 1:height(Litra(:,1))-1
    if Litra{i,1} == Litra{i+1,1}
        if Litra{i,16} + Litra{i,17} >= 1
            kmCount = kmCount + Litra{i,10};
            vector(j) = kmCount;
            j = j+1; 
            kmCount = 0;
        elseif Litra{i,16} + Litra{i,17} == 0
            kmCount = kmCount + Litra{i,10};
        end
    elseif Litra{i,1} ~= Litra{i+1,1}
            vector(j) = kmCount + Litra{i,10} ; 
            j = j+1; 
            kmCount = 0;
    end
end

max(nonzeros(vector))
min(nonzeros(vector))
mean(nonzeros(vector))