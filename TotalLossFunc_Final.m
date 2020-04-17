function totalloss = TotalLossFunc_Final(x, prevwear, V, f,kw, alphaw, betaw, gammaw, sigmaw, theta, Din, Df,lfinal)
% Total loss over all realizations in the final step

global nsam

% Estimate the depth in the final step

depth1 = DepthCut(Din, Df, x);
time1 = TimePart(Din, depth1, lfinal, V, f);

loss = zeros(nsam,1);

for i=1:nsam
    loss(i) = LossFunc_sample(x, prevwear(i), V, f,kw, alphaw(i), betaw(i), gammaw, sigmaw, theta, Din, Df,time1);
end

totalloss = mean(loss);