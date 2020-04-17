function diameter_cut = DiameterTurning(Df,comp, drift)
% function to compute final diameter considering tool wear compensation and
% drift

diameter_cut = Df-(2*comp)+drift;