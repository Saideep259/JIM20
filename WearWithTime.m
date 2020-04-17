function wear = WearWithTime(V,f,depth,t, kw, alphaw, betaw, gammaw, sigmaw)
% function to compute tool wear

wear = kw * (V^alphaw)*(f^betaw)*(depth^gammaw)*(t^sigmaw);