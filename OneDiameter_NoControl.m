% No control

clear; close all;clc

%% Model parameters of the wear empirical model
% Table 7 in the paper

kw_mean = 8.2676e-5;
alphaw_mean = 2.7195;
betaw_mean = 1.4899;
gammaw_mean = 1.2627;
sigmaw_mean = 0.4247;

%% Fixed Parameters

V = 60; % Cutting speed
f = 0.058; % Feed rate

lower_limit = 97.98; %Diameter lower bound
upper_limit = 98.02; %Diameter upper bound

comp = 0.0093; %Initial tool wear compensation

Din = 100; % Initial diameter
Df = 98; % Target diameter
L = 100; % Length of the part
theta = 15.0427; % Clearance angle

%% Total time taken to product a part

depth = DepthCut(Din, Df, comp); % computes depth of cut
timepart = TimePart(Din, depth, L, V, f); % time taken to produce a part

%% Calculate wear per time step

timestep = 0.25;
ntimesteps = ceil(timepart/timestep);

% Initialize variables to store diameter, wear, drift, length, and time
% values

diameterfinal_step = zeros(ntimesteps+1,1);
wear_step = zeros(ntimesteps+1,1);
drift_step = zeros(ntimesteps+1,1);
length_step = zeros(ntimesteps+1, 1);
time_step = zeros(ntimesteps+1,1);

for i=1:ntimesteps+1
    
    if i==ntimesteps+1
        time_step(i) = timepart;
        wear_step(i) = WearWithTime(V,f,depth,time_step(i),kw_mean, alphaw_mean, betaw_mean, gammaw_mean, sigmaw_mean);
        drift_step(i) = DriftWear(wear_step(i), pi*theta/180);
        diameterfinal_step(i) = DiameterTurning(Df,comp, drift_step(i));
        length_step(i) = L;
    else
        time_step(i) = (i-1)*timestep;
        wear_step(i) = WearWithTime(V,f,depth,time_step(i),kw_mean, alphaw_mean, betaw_mean, gammaw_mean, sigmaw_mean);
        drift_step(i) = DriftWear(wear_step(i), pi*theta/180);
        diameterfinal_step(i) = DiameterTurning(Df,comp, drift_step(i));
        length_step(i) = (time_step(i))*L/timepart;
    end
    
end

% Save data on all variables
save('OneDiameter_NoControl_Data.mat')









