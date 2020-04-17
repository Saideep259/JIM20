function twi = Estimate_t_w_i(V, f, depth, prev_wear, kw, alphaw, betaw, gammaw, sigmaw)
% Function to estimate tw,i
% Eq. (6) in the paper: "Optimal Cutting Parameters for Turning Operations with Costs of Quality and Tool Wear Compensation"
% Authors: Tamer F. Abdelmaguid and Tarek M. El-Hossainy

twi = ((1/kw)*(V^(-alphaw))*(f^(-betaw))*(depth^(-gammaw))*(prev_wear))^(1/sigmaw); 