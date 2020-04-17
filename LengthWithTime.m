function length = LengthWithTime(V,f,t,Din,depth)
% Compute the length of the part produced with time

length = 1000*V*f*t/(pi*(Din-depth));