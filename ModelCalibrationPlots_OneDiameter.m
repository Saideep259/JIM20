% Model Calibration Plots

clear; close all; clc


load('OneDiameter_Data.mat');

[fx1,x1] = ksdensity(alphaw_sam(:,1));
[fx2,x2] = ksdensity(alphaw_sam(:,end),'bandwidth',0.006);

[fx3,x3] = ksdensity(betaw_sam(:,1));
[fx4,x4] = ksdensity(betaw_sam(:,end),'bandwidth',0.006);

alphaproperties(x1, fx1,x2, fx2, [alphaw_true(k) alphaw_true(k)],[0 1.01*max(fx2)])

alphaproperties(x3, fx3,x4, fx4, [betaw_true(k) betaw_true(k)],[0 1.01*max(fx4)])