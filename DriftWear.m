function drift = DriftWear(currentw,theta)
% function to compute drift using tool wear and clearance angle(theta)

drift = 2*currentw*tan(theta);