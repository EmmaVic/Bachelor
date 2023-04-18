% inloading excel sheet
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 06/02/2023
%%

% import and change the two coloumns with times' data type to "datetime"
% run script

% removing coloumns
index=[22,21,19,17,16,12,10,9,8,6,4,2];
for i=1:length(index)
    Normaleuge2023(:,index(i)) = [];
end 
datetime.setDefaultFormats('default','HH:mm')

% laver tog 1 til at teste kode, skal ændres til alle tog efter
Tog1=Normaleuge2023(:,:);

%% Creating binary coloumn saying whether or not there can be cleaned on the stationed
binary = [];

for i=1:height(Tog1(:,1))
    t = Tog1{i,8};
  if t=='AB'||t=='AR'||t=='CPH'|| t=='ES'||t=='FA'||t=='FH'||t=='FLB'||t=='HG'||t=='HGL'||t=='KB'||t=='KH'||t=='KB'||t=='KK'||t=='LIH'||t=='NF'||t=='NÆ'||t=='OD'||t=='SDB'||t=='STR'||t=='TE'
      binary(i)=1;
  else binary(i)=0;
  end
end

binary = array2table(binary','VariableNames',{'BinaryC'});
Normal=[Tog1 binary];

%% creating coloumn with the time each train is stopped

Stoptime=[];
Stoptime(height(Normal(:,1)))=0;

for i=1:height(Normal(:,1))-1

Stoptime(i)=minutes(Normal{i+1,6}-Normal{i,7});

% tjekker om der starter nyt lbs nr
 if Normal{i,1} ~= Normal{i+1,1}
             Stoptime(i)=0;
 end



%tjekker om negativ, da det så er et nyt døgn
if Stoptime(i)<0
    Stoptime(i)=24*60+Stoptime(i);
end
end

Stoptable=array2table(Stoptime','VariableNames',{'StopTime'});
Normal=[Normal(:,1:7) Stoptable Normal(:,8:11)];

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

        elseif Normal{i,2} == 'ICA' || Normal{i,2} == 'ICU'
        Or(i) = 16;
        Tr(i) = 72;

        elseif Normal{i,2} == 'ICED'
        Or(i) = 39;
        Tr(i) = 125;

        elseif Normal{i,2} == 'MGA'
        Or(i) = 20;
        Tr(i) = 109;

        elseif Normal{i,2} == 'MPA'
        Or(i) = 11;
        Tr(i) = 56;

        elseif Normal{i,2} == 'MQ' || Normal{i,2} == 'MQS'
        Or(i) = 12;
        Tr(i) = 56;

        elseif Normal{i,2} == 'MR'
        Or(i) = 12;
        Tr(i) = 60;


    end
end

TRtable=array2table(Tr','VariableNames',{'Tr'});
Normal=[Normal TRtable];

ORtable=array2table(Or','VariableNames',{'Or'});
Normal=[Normal ORtable];

%% removing the rows that we dont need 

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

%% Creating column with different C values depening on the litra type 

for i = 1:height(Normal(:,1))
    if Normal{i,2} == 'ABS' || Normal{i,2} == 'B' || Normal{i,2} == 'BK'
        Cvalue(i) = 1261;

        elseif Normal{i,2} == 'ERF'
        Cvalue(i) = 1587; 

        elseif Normal{i,2} == 'ETS'
        Cvalue(i) = 1289;

        elseif Normal{i,2} == 'ICA'
        Cvalue(i) = 1639;

        elseif Normal{i,2} == 'MGA'
        Cvalue(i) = 1340;
    end
end

Cvaluetable=array2table(Cvalue','VariableNames',{'Cvalues'});
Normal=[Normal Cvaluetable];


%% exporting table to excel

filename='reviseddataAllData.xlsx';
writetable(Normal,filename,'Sheet',1,'Range','A1');



