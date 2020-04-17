function alphaproperties(X1, Y1, X2, Y2, X3, Y3)
%  CREATEFIGURE(X1, Y1, X2, Y2, X3, Y3)
%  X1:  vector of x data
%  Y1:  vector of y data
%  X2:  vector of x data
%  Y2:  vector of y data
%  X3:  vector of x data
%  Y3:  vector of y data

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontWeight','bold',...
    'FontSize',30,...
    'FontName','Times');
box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(X1,Y1,'LineWidth',4);

% Create plot
plot(X2,Y2,'LineWidth',4);

% Create plot
plot(X3,Y3,'LineWidth',5,'Color',[0 0.498039215803146 0]);

% Create xlabel
xlabel('\alpha_w','FontSize',40);

% Create ylabel
ylabel('PDF');

