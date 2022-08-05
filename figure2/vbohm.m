function [value, isterminal, direction] = vbohm(x,y)
% Detects when the perpendicular component of the ion flow velocity is 
% equal to the Bohm acoustic speed, Vx = 1.0, to stop ODE integration
value      = y(1) - 1.0; 
isterminal = 1;
direction  = 0;
