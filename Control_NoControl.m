%  Comparison plots

clear; close all; clc

Din = 100;
Df = 98;
L = 100;

lower_limit = 97.98;
upper_limit = 98.02;

controldata = load('OneDiameter_Data.mat');
nocontroldata = load('OneDiameter_NoControl_Data.mat');

lengthdata = controldata.length_step_true;
lengthdata(end) = L;

length_double = controldata.length_total;

diameter_nocontrol = nocontroldata.diameterfinal_step;
diameter_control = controldata. diameter_total;

%% Plotting
% Figure 10 of the paper

ControlNoControlProperties(lengthdata, diameter_nocontrol,length_double, diameter_control,[0 L],[Df Df;upper_limit, upper_limit;lower_limit,lower_limit] )

%% Plot the increase in tool wear compensation with the length of the part

comp_step = controldata.comp_step_true;
comp_step1 = controldata.comp_step;

% Plotting both computed and actually implemented tool wear compensation
% Figure 11 of the paper

figure1 = figure();

axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontWeight','bold',...
    'FontSize',30,...
    'FontName','Times');
box(axes1,'on');
hold(axes1,'on');


plot(lengthdata(2:end),comp_step1(2:end),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],...
    'MarkerSize',10,...
    'Marker','pentagram',...
    'LineWidth',4,...
    'Color',[0 0.447058826684952 0.74117648601532]);

hold on


plot(lengthdata(2:end),comp_step(2:end),...
    'MarkerFaceColor',[0 0.498039215803146 0],...
    'MarkerEdgeColor',[0 0.498039215803146 0],...
    'MarkerSize',10,...
    'Marker','pentagram',...
    'LineWidth',4,'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);

hold off


legend('Computed Tool Wear', 'Actual Tool Wear')

% Create xlabel
xlabel('Distance along the length of the part');

% Create ylabel
ylabel('Tool wear compensation');


%% Computing uncertainty (Figure 12 of the paper)

reldata = controldata.Total_comp_rel;
calibdata = controldata.Total_calibration_rel;

figure2 = figure();

axes1 = axes('Parent',figure2,'YGrid','on','XGrid','on','FontWeight','bold',...
    'FontSize',30,...
    'FontName','Times');
box(axes1,'on');
hold(axes1,'on');


plot(lengthdata(2:end),reldata(2:end),'kx', 'MarkerSize',10, 'LineWidth',6)
hold on

plot(lengthdata(2:end),calibdata(2:end),'ro', 'MarkerSize',10, 'LineWidth',3)

hold off


legend('Resources to compute tool wear compensation', 'Resources to perform calibration')

% Create xlabel
xlabel('Distance along the length of the part');

% Create ylabel
ylabel('Completion of analysis');

axis([0 100 -1 2])








