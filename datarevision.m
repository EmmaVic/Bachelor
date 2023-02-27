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

%% creating two coloumns with TR and OR times for each train type 

Tr=[];
Or=[];
 
j = 1; 

for i = 1:height(Normaleuge2023(:,1))-1

    if Normaleuge2023{i,1} ~= Normaleuge2023{i+1,1}
        
        if Normaleuge2023{i,2} == 'ABS' || Normaleuge2023{i,2} == 'B' || Normaleuge2023{i,2} == 'BK'
        Tr(j) = 47;
        Or(j) = 175;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ERF'
        Tr(j) = 20;
        Or(j) = 80;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ETS'
        Tr(j) = 15;
        Or(j) = 104;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ICA' || Normaleuge2023{i,2} == 'ICU'
        Tr(j) = 16;
        Or(j) = 72;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'ICED'
        Tr(j) = 39;
        Or(j) = 125;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MGA'
        Tr(j) = 20;
        Or(j) = 109;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MPA'
        Tr(j) = 11;
        Or(j) = 56;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MQ' || Normaleuge2023{i,2} == 'MQS'
        Tr(j) = 12;
        Or(j) = 56;
        j = j+1;

        elseif Normaleuge2023{i,2} == 'MR'
        Tr(j) = 12;
        Or(j) = 60;
        j = j+1;

        end
    end
end

Trtable=array2table(Or','VariableNames',{'Tr'});
Cleaningschedule=[Trtable];

Ortable=array2table(Tr','VariableNames',{'Or'});
Cleaningschedule=[Cleaningschedule Ortable];

%% exporting table to excel

filename='reviseddataTog1.xlsx';
writetable(Normal,filename,'Sheet',1,'Range','A1');

%%
filename='Cleaningschedule.xlsx';
writetable(Cleaningschedule,filename,'Sheet',1,'Range','A1');
