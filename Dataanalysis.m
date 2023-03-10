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

max(nonzeros(KmBetween))
min(nonzeros(KmBetween))
mean(nonzeros(KmBetween))

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