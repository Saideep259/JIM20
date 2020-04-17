
function depth = DepthCut(Din,Df,Comp)
% Function to compute depth of cut

% Input parameters
% Din: Initial diameter
% Df: Final diameter
% Comp: Tool wear compensation

depth = 0.5*(Din-Df) + Comp;