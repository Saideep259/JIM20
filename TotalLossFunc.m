function totalloss = TotalLossFunc(x, prevwear, V, f,kw, alphaw, betaw, gammaw, sigmaw, theta, Din, Df,tstep)
% Function to compute the total loss function (except for the final step)
% All the steps other than the final step has the same processing time

% The processing time in the final time may be different (this is dependent
% on the length of the part remaining to the processed in the final step

% We have several loss values considering the uncertainty in various
% parameters

global nsam

loss = zeros(nsam,1);

for i=1:nsam
    loss(i) = LossFunc_sample(x, prevwear(i), V, f,kw, alphaw(i), betaw(i), gammaw, sigmaw, theta, Din, Df,tstep);
end


% Compute the average loss value
totalloss = mean(loss);