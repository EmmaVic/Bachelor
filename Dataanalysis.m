% Dataanalysis 
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 13/03/2023
%% Dataanalysis - changing the data to draw information from

% import and change the two coloumns with times' data type to "datetime"
% 

% removing coloumns
index=[22,21,19,17,16,12,9,8,6,4,2];
for i=1:length(index)
    Normaleuge2023(:,index(i)) = [];
end 
datetime.setDefaultFormats('default','HH:mm')

Normal = Normaleuge2023(:,:);

% Creating binary coloumn saying whether or not there can be cleaned on the stationed
binary = [];

for i=1:height(Normal(:,1))
    t = Normal{i,9};
  if t=='AB'||t=='AR'||t=='CPH'|| t=='ES'||t=='FA'||t=='FH'||t=='FLB'||t=='HG'||t=='HGL'||t=='KB'||t=='KH'||t=='KB'||t=='KK'||t=='LIH'||t=='NF'||t=='NÆ'||t=='OD'||t=='SDB'||t=='STR'||t=='TE'
      binary(i)=1;
  else binary(i)=0;
  end
end

binary = array2table(binary','VariableNames',{'BinaryC'});
Normal=[Normal binary];

% removing the rows that we dont need 

in = [];
j = 1;

for i = 1:height(Normal(:,1))
    if Normal{i,2} == 'EB' || Normal{i,2} == 'EA' || Normal{i,2} == 'ME'
        in(j) = i;
        j = j+1;
    elseif Normal{i,10} == 0
        in(j) = i;
        j = j+1;
    end
end


for i = 0:length(in)-1
   Normal(in(length(in)-i),:) = [];
end 

%% The analysis

%% New calculation of the kilometers between cleanings

j = 1; 
vector = [];
kmCount = 0;

for i = 1:height(Normal(:,1))-1
    if Normal{i,1} == Normal{i+1,1}
        if Normal{i,5} == "TR" || Normal{i,5} == "OR"
        vector(j) = kmCount;
        j = j+1; 
        kmCount = Normal{i,10};
        elseif Normal{i,5} ~= "TR" || Normal{i,5} ~= "OR"
        kmCount = kmCount + Normal{i,10};
        end
    elseif Normal{i,1} ~= Normal{i+1,1}
        vector(j) = kmCount + Normal{i,10} ; 
        j = j+1; 
        kmCount = 0;
    end
end

max(nonzeros(vector))
min(nonzeros(vector))
mean(nonzeros(vector))

%% Number of cleanings in total
index = [];
antal = 0;
antalTR = 0;
antalOR = 0;
j = 1;

for i = 1: height(Normal{:,1})
    if Normal{i,5} == "TR" || Normal{i,5} == "OR"
        antal = antal+1;
        index(j) = i;
        j = j+1;
    end
end

for i = 1: height(Normal{:,1})
    if Normal{i,5} == "TR"
        antalTR = antalTR+1;
    elseif Normal{i,5} == "OR"
        antalOR = antalOR+1;
    end
end

%% The different litra types 

Litra1 = Normal(1:1803,:);
Litra2 = Normal(1804:2551,:);
Litra3 = Normal(2552:6758,:);
Litra4 = Normal(6759:7859,:);
Litra5 = Normal(7860:8922,:);
Litra6 = Normal(8923:11575,:);
Litra7 = Normal(11576:end,:);

%% max, min and mean on the different litratypes

j = 1; 
vector = [];
kmCount = 0;

Litra = Litra7;

for i = 1:height(Litra(:,1))-1
    if Litra{i,1} == Litra{i+1,1}
        if Litra{i,5} == "TR" || Litra{i,5} == "OR"
        vector(j) = kmCount;
        j = j+1; 
        kmCount = Litra{i,10};
        elseif Litra{i,5} ~= "TR" || Litra{i,5} ~= "OR"
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

%% Hvor mange or og TR pr litra
antalOR = 0;
antalTR = 0; 

Litra = Litra1; 

for i = 1: height(Litra{:,1})
    if Litra{i,5} == "TR"
        antalTR = antalTR+1;
    elseif Litra{i,5} == "OR"
        antalOR = antalOR+1;
    end
end

%% kilometer between OR 

j = 1; 
vector = [];
kmCount = 0;

Litra = Normal;

for i = 1:height(Litra(:,1))-1
    if Litra{i,1} == Litra{i+1,1}
        if Litra{i,5} == "OR"
        vector(j) = kmCount;
        j = j+1; 
        kmCount = Litra{i,10};
        elseif Litra{i,5} ~= "OR"
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

%% kilometer between Tr 
j = 1; 
vector = [];
kmCount = 0;

Litra = Normal;

for i = 1:height(Litra(:,1))-1
    if Litra{i,1} == Litra{i+1,1}
        if Litra{i,5} == "TR"
        vector(j) = kmCount;
        j = j+1; 
        kmCount = Litra{i,10};
        elseif Litra{i,5} ~= "TR"
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

%% Creating Or and Tr for each station 

for i = 1:height(Normal(:,1))
    if Normal{i,2} == 'ABS' || Normal{i,2} == 'B' || Normal{i,2} == 'BK'
        Or(i) = 47;
        Tr(i) = 175;

        elseif Normal{i,2} == 'ERF'
        Or(i) = 20;
        Tr(i) = 80;

        elseif Normal{i,2} == 'ETS'
        Or(i) = 15;
        Tr(i) = 104;

        elseif Normal{i,2} == 'ICA' 
        Or(i) = 16;
        Tr(i) = 72;

        elseif Normal{i,2} == 'MGA'
        Or(i) = 20;
        Tr(i) = 109;


    end
end

TRtable=array2table(Tr','VariableNames',{'Tr'});
Normal=[Normal TRtable];

ORtable=array2table(Or','VariableNames',{'Or'});
Normal=[Normal ORtable];

%% Calculatng the objective value with their soultion 
Z = 0; 

for i = 1:height(Normal(:,1))
    if Normal{i,5} == "TR" 
        Z = Z + Normal{i,13};
    elseif Normal{i,5} == "OR"
        Z = Z + Normal{i,14};
    end
end














%%
% NOT IN USE 
%% Number op kilometers between cleanings on same lbs number:
KmBetween = [];
k = 1; 
for i = 1:length(index)-1
    if Normal{index(i),1} == Normal{index(i+1),1}
        KmBetween(k) = sum(Normal{index(i):index(i+1)-1,10});
        k = k+1;
    end
end

max(nonzeros(KmBetween))
min(nonzeros(KmBetween))
mean(nonzeros(KmBetween))


%% Number of km for each train 
numberKM = [];
numberKMindex = [];
q = 1;

for i = 1: height(Normal{:,1})-1
    if Normal{i,11} > Normal{i+1,11}
        numberKM(q) = Normal{i,11};
        numberKMindex(q) = i;
        q = q+1;
    end
end

[M,I] = max(numberKM)

% Number of trains
numberTrain = 0;
for i = 1: height(Normal{:,1})-1
    if Normal{i,1} ~= Normal{i+1,1}
       numberTrain = numberTrain+1;
    end
end

%% 
% Finding each different Litratype and their min and max between cleanings

tal = 0;
info = [];
for i = 1:height(Normal(:,1))-1
    if Normal{i,2}~=Normal{i+1,2}
        tal = tal + 1; 
        info(tal)=i+1;
    end
end

Litra1 = Normal(1:1803,:);
Litra2 = Normal(1804:2551,:);
Litra3 = Normal(2552:6758,:);
Litra4 = Normal(6759:7859,:);
Litra5 = Normal(7860:8922,:);
Litra6 = Normal(8923:11575,:);
Litra7 = Normal(11576:end,:);

indexL1 = []; antalL1 = 0; L1 = 1;
indexL2 = []; antalL2 = 0; L2 = 1; 
indexL3 = []; antalL3 = 0; L3 = 1; 
indexL4 = []; antalL4 = 0; L4 = 1; 
indexL5 = []; antalL5 = 0; L5 = 1; 
indexL6 = []; antalL6 = 0; L6 = 1;
indexL7 = []; antalL7 = 0; L7 = 1;

for i = 1: height(Litra1{:,1})
    if Litra1{i,5} == "TR" || Litra1{i,5} == "OR"
        antalL1 = antalL1+1;
        indexL1(L1) = i;
        L1 = L1+1;
    end
end

for i = 1: height(Litra2{:,1})
    if Litra2{i,5} == "TR" || Litra2{i,5} == "OR"
        antalL2 = antalL2+1;
        indexL2(L2) = i;
        L2 = L2+1;
    end
end

for i = 1: height(Litra3{:,1})
    if Litra3{i,5} == "TR" || Litra3{i,5} == "OR"
        antalL3 = antalL3+1;
        indexL3(L3) = i;
        L3 = L3+1;
    end
end

for i = 1: height(Litra4{:,1})
    if Litra4{i,5} == "TR" || Litra4{i,5} == "OR"
        antalL4 = antalL4+1;
        indexL4(L4) = i;
        L4 = L4+1;
    end
end

for i = 1: height(Litra5{:,1})
    if Litra5{i,5} == "TR" || Litra5{i,5} == "OR"
        antalL5 = antalL5+1;
        indexL5(L5) = i;
        L5 = L5+1;
    end
end

for i = 1: height(Litra6{:,1})
    if Litra6{i,5} == "TR" || Litra6{i,5} == "OR"
        antalL6 = antalL6+1;
        indexL6(L6) = i;
        L6 = L6+1;
    end
end

for i = 1: height(Litra7{:,1})
    if Litra7{i,5} == "TR" || Litra7{i,5} == "OR"
        antalL7 = antalL7+1;
        indexL7(L7) = i;
        L7 = L7+1;
    end
end

KmBetweenL1 = [];
KmBetweenL2 = [];
KmBetweenL3 = [];
KmBetweenL4 = [];
KmBetweenL5 = [];
KmBetweenL6 = [];
KmBetweenL7 = [];
%%

for i = 1:length(indexL1)-1
    if Litra1{indexL1(i),1} == Litra1{indexL1(i+1),1}
        KmBetweenL1(i) = sum(Litra1{indexL1(i):indexL1(i+1)-1,10});
    elseif Litra1{indexL1(i),1} < Litra1{indexL1(i+1),1}
        p = Litra1{indexL1(i),1};
        KmBetweenL1(i) = sum(Litra1{indexL1(i):numberKMindex(p),10});
    end
end

%%
for i = 1:length(indexL2)-1
    if Litra2{indexL2(i),1} == Litra2{indexL2(i+1),1}
        KmBetweenL2(i) = sum(Litra2{indexL2(i):indexL2(i+1)-1,10});
    elseif Litra2{indexL2(i),1} < Litra2{indexL2(i+1),1}
        p = Litra2{indexL2(i),1};
        KmBetweenL2(i) = sum(Litra2{indexL2(i):numberKMindex(46+p),10});
    end
end

for i = 1:length(indexL3)-1
    if Litra3{indexL3(i),1} == Litra3{indexL3(i+1),1}
        KmBetweenL3(i) = sum(Litra3{indexL3(i):indexL3(i+1)-1,10});
    end
end

for i = 1:length(indexL4)-1
    if Litra4{indexL4(i),1} == Litra4{indexL4(i+1),1}
        KmBetweenL4(i) = sum(Litra4{indexL4(i):indexL4(i+1)-1,10});
    end
end

for i = 1:length(indexL5)-1
    if Litra5{indexL5(i),1} == Litra5{indexL5(i+1),1}
        KmBetweenL5(i) = sum(Litra5{indexL5(i):indexL5(i+1)-1,10});
    end
end

for i = 1:length(indexL6)-1
    if Litra6{indexL6(i),1} == Litra6{indexL6(i+1),1}
        KmBetweenL6(i) = sum(Litra6{indexL6(i):indexL6(i+1)-1,10});
    end
end

for i = 1:length(indexL7)-1
    if Litra7{indexL7(i),1} == Litra7{indexL7(i+1),1}
        KmBetweenL7(i) = sum(Litra7{indexL7(i):indexL7(i+1)-1,10});
    end
end

antalL1
max(nonzeros(KmBetweenL1))
min(nonzeros(KmBetweenL1))
mean(nonzeros(KmBetweenL1))
