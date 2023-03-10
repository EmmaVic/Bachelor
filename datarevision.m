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


%% exporting table to excel

filename='reviseddataAllData.xlsx';
writetable(Normal,filename,'Sheet',1,'Range','A1');









%% creating two coloumns with TR and OR times for each train type 

Tr=[];
Or=[];
 
j = 1; 

for i = 1:height(Normaleuge2023(:,1))-1

    if Normaleuge2023{i,1} ~= Normaleuge2023{i+1,1}
        
        if Normaleuge2023{i,2} == 'ABS' || Normaleuge2023{i,2} == 'B' || Normaleuge2023{i,2} == 'BK'
        Or(j) = 47;
        Tr(j) = 175;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ERF'
        Or(j) = 20;
        Tr(j) = 80;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ETS'
        Or(j) = 15;
        Tr(j) = 104;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ICA' || Normaleuge2023{i,2} == 'ICU'
        Or(j) = 16;
        Tr(j) = 72;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ICED'
        Or(j) = 39;
        Tr(j) = 125;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MGA'
        Or(j) = 20;
        Tr(j) = 109;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MPA'
        Or(j) = 11;
        Tr(j) = 56;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MQ' || Normaleuge2023{i,2} == 'MQS'
        Or(j) = 12;
        Tr(j) = 56;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MR'
        Or(j) = 12;
        Tr(j) = 60;
        j = j+1;

        end
    end
end

Trtable=array2table(Tr','VariableNames',{'Tr'});
Cleaningschedule=[Trtable];

Ortable=array2table(Or','VariableNames',{'Or'});
Cleaningschedule=[Cleaningschedule Ortable];


%%
filename='Cleaningschedule.xlsx';
writetable(Cleaningschedule,filename,'Sheet',1,'Range','A1');
