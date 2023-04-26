% Plot
% Sif Egelund Christensen
% Emma Victoria Vendel Lind
% 13/03/2023

%%

x = [50,100,300,400,500,600,800,1200,1800];
yobjective = [4.7496, 4.7496, 4.7496, 4.7496, 4.7496, 4.7480]; % *10^4
ybestbound = [4.5839, 4.5919, 4.5952, 4.5961, 4.5950, 4.6070]; % *10^4
yprocent = [4.99, 4.12, 3.49, 3.32, 3.25, 3.25, 3.25, 3.02, 2.97]; %ved 600 3,23% egentlig 

%%
figure
plot(x,yprocent, 'b--o')
title('Solution quality over time')
xlabel('runtime in [s]')
ylabel('Gap in [%]')
% the gap is between best objective value found and best lower bound found
% in [%]