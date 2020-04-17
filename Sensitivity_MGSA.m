%% Sensitivity analysis

% Using sensitivity analysis, we attempt to quantify the influence of
% various parameters (Comp, theta, kw, alphaw, betaw, gammaw, sigmaw) on
% the final diameter

% Goal: Dimension reduction 

clear; close all;clc

rng(1)

nsam = 3600;

%% Generate samples

kw_mean = 8.2961e-5;
alphaw_mean = 2.747;
betaw_mean = 1.473;
gammaw_mean = 1.261;
sigmaw_mean = 0.43;

kw_std = 0.01*kw_mean;
alphaw_std = 0.01*alphaw_mean;
betaw_std = 0.01*betaw_mean;
gammaw_std = 0.01*gammaw_mean;
sigmaw_std = 0.01*sigmaw_mean;

kw_sam = normrnd(kw_mean, kw_std, nsam, 1);
alphaw_sam = normrnd(alphaw_mean, alphaw_std, nsam, 1);
betaw_sam = normrnd(betaw_mean, betaw_std,nsam,1);
gammaw_sam = normrnd(gammaw_mean, gammaw_std, nsam, 1);
sigmaw_sam = normrnd(sigmaw_mean, sigmaw_std, nsam, 1);

%% 

comp_mean = 0.9*0.01;
comp_std = 0.0005;

comp_sam = normrnd(comp_mean, comp_std, nsam,1);

%% 
theta_mean = 15;
theta_std = 0.1;

theta_sam =normrnd(theta_mean, theta_std, nsam, 1);

%% Fixed Parameters

V = 60;
f = 0.058;
Din = 100;
Df = 98;
L = 100;

%% Final diameter

depth_sam = DepthCut(Din, Df, comp_sam);
timepart_sam = zeros(nsam,1);

wear_sam = zeros(nsam,1);
drift_sam = zeros(nsam,1);
diameter_final = zeros(nsam,1);

for i=1:nsam
    timepart_sam(i) = TimePart(Din, depth_sam(i), L, V, f);
    wear_sam(i) = WearWithTime(V, f, depth_sam(i), timepart_sam(i), kw_sam(i), alphaw_sam(i), betaw_sam(i), gammaw_sam(i), sigmaw_sam(i));
    drift_sam(i) = DriftWear(wear_sam(i), (pi/180)*theta_sam(i));
    diameter_final(i) = DiameterTurning(Df, comp_sam(i), drift_sam(i));
end

input = [kw_sam, alphaw_sam, betaw_sam, gammaw_sam, sigmaw_sam, comp_sam, theta_sam];
output = diameter_final;

sensindices = MGSA_FirstOrder(input, output, sqrt(nsam));

save('SensitivityIndices.mat')


