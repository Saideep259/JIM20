function [final_dia_sample,start_dia_sample] = Cons_sample(comp, prevwear, V, f,kw, alphaw, betaw, gammaw, sigmaw, theta, Din, Df,tstep)
% Function to compute the start and final diameters in a time step

depth = DepthCut(Din, Df, comp);
twi = Estimate_t_w_i(V, f, depth, prevwear, kw, alphaw, betaw, gammaw, sigmaw);

% Computation of tool wear
currwear_end = WearWithTime(V,f,depth,twi+tstep, kw, alphaw, betaw, gammaw, sigmaw); % total wear at the end of time step
currwear_start = WearWithTime(V,f,depth,twi, kw, alphaw, betaw, gammaw, sigmaw); % wear at the beginning of the time step

% Computation of drift
drift_end = DriftWear(currwear_end, theta);
drift_start = DriftWear(currwear_start, theta);

% Computation of start and final diameters using the tool wear compensation
% and drift

final_dia_sample = DiameterTurning(Df, comp, drift_end);
start_dia_sample = DiameterTurning(Df, comp, drift_start);

