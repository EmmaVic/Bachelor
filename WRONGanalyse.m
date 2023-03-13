% Dataanalysis 
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 13/03/2023
%%

% import and change the two coloumns with times' data type to "datetime"
% 

% removing coloumns
index=[22,21,19,17,16,12,9,8,6,4,2];
for i=1:length(index)
    Normaleuge2023(:,index(i)) = [];
end 
datetime.setDefaultFormats('default','HH:mm')

%%
% laver de første 3 tog til at teste kode, skal ændres til alle tog efter
Normal=Normaleuge2023(1:154,:);

%% Creating binary coloumn saying whether or not there can be cleaned on the stationed
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

%% %% removing the rows that we dont need 

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

%% TR
KiloTR = [];

NumberofTR = 0;
k = 0;
p = 0; 
i = 2;

Lbs = [1:44,1:8,1:96,1:40,1:19,1:49,1:19];

for j = 1:length(Lbs)
    
    while Normal{i,1} == Lbs(j)

         if Normal{i-1,1} ~= Lbs(j)
            p = p+1;
            KiloTR(p) = Normal{i,10};
            k = i+1; 
            while Normal{k,5} ~= "TR" && Normal{k,1} == Lbs(j)
                KiloTR(p) = KiloTR(p) + Normal{k,10};
                k = k+1;
            end
            i = k-1;
        
         elseif Normal{i,5} == "TR" && Normal{i,1} == Lbs(j)
            p = p+1;
            KiloTR(p) = Normal{i,10};
            k = i+1; 
            NumberofTR = NumberofTR+1; 
                while Normal{k,5} ~= "TR" && Normal{k,1} == Lbs(j)
                    KiloTR(p) = KiloTR(p) + Normal{k,10};
                    k = k+1;
                end
            i = k-1;
        end
        i = i+1;
    end
end


% The info:
max(KiloTR)
min(KiloTR)
mean(KiloTR)

%% OR
KiloOR = [];

NumberofOR = 0;
k = 0;
p = 0; 
i = 2;

Lbs = [1:44,1:8,1:96,1:40,1:19,1:49,1:19];

for j = 1:length(Lbs)
    
    while Normal{i,1} == Lbs(j)
        if Normal{i-1,1} ~= Lbs(j)
            p = p+1;
            KiloOR(p) = Normal{i,10};
            k = i+1;
            while Normal{k,5} ~= "OR" && Normal{k,1} == Lbs(j)
                KiloOR(p) = KiloOR(p) + Normal{k,10};
                k = k+1;
            end
            i = k-1;
        elseif Normal{i,5} == "OR" && Normal{i,1} == Lbs(j)
            p = p+1;
            KiloOR(p) = Normal{i,10};
            k = i+1; 
            NumberofOR = NumberofOR+1; 
                while Normal{k,5} ~= "OR" && Normal{k,1} == Lbs(j)
                    KiloOR(p) = KiloOR(p) + Normal{k,10};
                    k = k+1;
                end
            i = k-1;
        end
        i = i+1;
    end
end


% The info:
max(KiloOR)
min(KiloOR)
mean(KiloOR)

%% TR and OR
Kilo = [];

NumberofCleaning = 0;
k = 0;
p = 0; 
i = 2;

Lbs = [1:44,1:8,1:96,1:40,1:19,1:49,1:19];
%loop over løbs numre
for j = 1:length(Lbs)
    
    %tjekker for om togturen hører til løbsnumeret
    while Normal{i,1} == Lbs(j)
        %tjekker om der lige er skiftet løbsnummer - hvis der er dette
        %startes der en optælling af kilometer indtil første rengøring
        if Normal{i-1,1} ~= Lbs(j)
            p = p+1;
            Kilo(p) = Normal{i,10};
            k = i+1;
            while Normal{k,5} ~= "OR" && Normal{k,5} ~= "TR" && Normal{k,1} == Lbs(j) 
                Kilo(p) = Kilo(p) + Normal{k,10};
                k = k+1;
            end
            i = k-1;
        %laver optælling mellem hver rengøring og sikre at det er for smmen
        %løbsnummer
        elseif (Normal{i,5} == "OR" && Normal{i,1} == Lbs(j)) || (Normal{i,5} == "TR" && Normal{i,1} == Lbs(j))
            p = p+1;
            Kilo(p) = Normal{i,10};
            k = i+1; 
            %tæller antallet af rengøringer
            NumberofCleaning = NumberofCleaning+1; 
                while Normal{k,5} ~= "OR" && Normal{k,5} ~= "TR" && Normal{k,1} == Lbs(j) 
                    Kilo(p) = Kilo(p) + Normal{k,10};
                    k = k+1;
                end
            i = k-1;
        end
        i = i+1;
    end
end


% The info:
max(Kilo)
min(Kilo)
mean(Kilo)

%% 

% Number of cleanings in total
index = [];
antal = 0;
j = 1;

for i = 1: height(Normal{:,1})
    if Normal{i,5} == "TR" || Normal{i,5} == "OR"
        antal = antal+1;
        index(j) = i;
        j = j+1;
    end
end

% Number op kilometers between cleanings on same lbs number:
KmBetween = [];
for i = 1:length(index)-1
    if Normal{index(i),1} == Normal{index(i+1),1}
        KmBetween(i) = sum(Normal{index(i):index(i+1),10});
    end
end

%Number for the different celanings:
NumberOR = 0; 
NumberTR = 0;

for i = 1: height(Normal{:,1})
    if Normal{i,5} == "OR"
        NumberOR = NumberOR+1;
    elseif Normal{i,5} == "TR"
        NumberTR = NumberTR+1;
    end
end