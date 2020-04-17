function ControlNoControlProperties(X1, Y1, X2, Y2, X3, YMatrix1)
%  CREATEFIGURE(X1, Y1, X2, Y2, X3, YMATRIX1)
%  X1:  vector of x data
%  Y1:  vector of y data
%  X2:  vector of x data
%  Y2:  vector of y data
%  X3:  vector of x data
%  YMATRIX1:  matrix of y data

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontWeight','bold',...
    'FontSize',30,...
    'FontName','Times');
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 100]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[97.97 98.1]);
box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(X1,Y1,'DisplayName','Without Control',...
    'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerEdgeColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerSize',10,...
    'Marker','hexagram',...
    'LineWidth',4);

% Create plot
plot(X2,Y2,'DisplayName','With Control',...
    'MarkerFaceColor',[0.850980401039124 0.325490206480026 0.0980392172932625],...
    'MarkerEdgeColor',[0.850980401039124 0.325490206480026 0.0980392172932625],...
    'MarkerSize',10,...
    'Marker','pentagram',...
    'LineWidth',4);

% Create multiple lines using matrix input to plot
plot1 = plot(X3,YMatrix1,'LineWidth',4,'Parent',axes1,'LineStyle','--');
set(plot1(1),'DisplayName','Target Diameter',...
    'Color',[0 0.498039215803146 0],...
    'LineStyle','-');
set(plot1(2),'DisplayName','Upper Limit');
set(plot1(3),'DisplayName','Lower Limit',...
    'Color',[0.635294139385223 0.0784313753247261 0.184313729405403]);

% Create xlabel
xlabel('Distance along the length of the part');

% Create ylabel
ylabel('Output diameter');

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.142149700739367 0.658399996442477 0.219682830441466 0.280977312390925]);

