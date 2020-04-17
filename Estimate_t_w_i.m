function twi = Estimate_t_w_i(V, f, depth, prev_wear, kw, alphaw, betaw, gammaw, sigmaw)
% Function to estimate tw,i
% tw,i is the equivalent time that could have been spent in processing part i to result in the same amount of tool wear that is reached at the end of processing i-1 parts 


twi = ((1/kw)*(V^(-alphaw))*(f^(-betaw))*(depth^(-gammaw))*(prev_wear))^(1/sigmaw); 