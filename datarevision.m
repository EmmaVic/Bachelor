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
Normaleuge2023(:,index(i))=[];
end 
datetime.setDefaultFormats('default','HH:mm')

% laver tog 1 til at teste kode, skal ændres til alle tog efter
Tog1=Normaleuge2023(1:54,:);

%% Creating binary coloumn saying whether or not there can be cleaned on the stationed
binary = [];

for i=1:height(Tog1(:,1))
    t = Tog1{i,8};
  if t=='AB'|t=='AR'|t=='CPH'| t=='ES'|t=='FA'|t=='FH'|t=='FLB'|t=='HG'|t=='HGL'|t=='KB'|t=='KH'|t=='KB'|t=='KK'|t=='LIH'|t=='NF'|t=='NÆ'|t=='OD'|t=='SDB'|t=='STR'|t=='TE';
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


%% exporting table to excel

filename='reviseddataTog1.xlsx';
writetable(Normal,filename,'Sheet',1,'Range','A1');

