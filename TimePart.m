function timepart = TimePart(Din, depth, L, V, f)
% Computes time taken to produce a part

Dmean = Din-depth;
timepart = (pi*Dmean*L)/(1000*V*f);