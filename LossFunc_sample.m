function loss_sample = LossFunc_sample(comp, prevwear, V, f,kw, alphaw, betaw, gammaw, sigmaw, theta, Din, Df, tstep)
% Function to compute loss function associated with one realization. This needs to be repeated for all realizations

depth = DepthCut(Din, Df, comp);
twi = Estimate_t_w_i(V, f, depth, prevwear, kw, alphaw, betaw, gammaw, sigmaw);

%currwear = WearWithTime(V,f,depth,twi+tstep, kw, alphaw, betaw, gammaw, sigmaw); % total wear at the end of time step
currwear_start = WearWithTime(V,f,depth,twi, kw, alphaw, betaw, gammaw, sigmaw); % total wear at middle of time step
currwear_mid = WearWithTime(V,f,depth,twi+tstep/2, kw, alphaw, betaw, gammaw, sigmaw);
currwear_end = WearWithTime(V,f,depth,twi+tstep, kw, alphaw, betaw, gammaw, sigmaw);

drift_start = DriftWear(currwear_start, theta);
drift_mid = DriftWear(currwear_mid, theta);
drift_end = DriftWear(currwear_end, theta);

loss_sample = 1e7*(tstep/4)*((2*comp - drift_start)^2 + 2*(2*comp - drift_mid)^2 + (2*comp - drift_end)^2);

