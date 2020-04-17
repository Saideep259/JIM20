%% Plotting diameter profiles when multiple parts are produced

clear; close all;clc

load('TurningProcess_comp.mat')

figure()

plot([0,L],[Df,Df],'Color',[0 0.45 0.74], 'LineWidth',4)

hold on
plot([0,L],[upper_limit, upper_limit],'--', 'LineWidth',4)
plot([0,L],[lower_limit,lower_limit],'--', 'LineWidth',4)

for i=1:nrepeat
    plot(length_repeat{i},diameter_true{i},'LineWidth',2, 'MarkerSize',5,'Marker','hexagram')
end

plot([0,L],[Df,Df],'Color',[0 0.45 0.74], 'LineWidth',4)

hold on

hold off

legend('Target Diameter','Upper Limit','Lower Limit')

axis([0 100 lower_limit-0.005 upper_limit+0.015])

xlabel('Distance along the length of a part')
ylabel('Output diameter (mm)')