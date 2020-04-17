function [c, ceq] = TotalCons(x, prevwear, V, f,kw, alphaw, betaw, gammaw, sigmaw, theta, Din, Df,tstep)

% Function to evaluate the probabilistic constraint
% There is a separate function in the folder to evaluate the constraint in the final time
% step (TotalCons_Final)

global nsam lower_limit upper_limit

final_diameter_sam = zeros(nsam,1);
start_diameter_sam = zeros(nsam,1);

for i=1:nsam
    [final_diameter_sam(i), start_diameter_sam(i)]= Cons_sample(x, prevwear(i), V, f,kw, alphaw(i), betaw(i), gammaw, sigmaw, theta, Din, Df,tstep);
end

final_check_upper = final_diameter_sam < upper_limit;
final_check_lower = final_diameter_sam > lower_limit;

start_check_upper = start_diameter_sam < upper_limit;
start_check_lower = start_diameter_sam > lower_limit;

satisfyall = sum(final_check_upper + final_check_lower + start_check_upper + start_check_lower == 4);

c = 0.95 - satisfyall/nsam;
ceq = [];