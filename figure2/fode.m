function ydot = fode(x,y,params)
% R. Khaziev, D. Curreli, Ion energy-angle distribution functions at 
% the plasma-material interface in oblique magnetic fields, 
% Physics of Plasmas, Vol. 22, Is. 4, 043503 (2015)

omega_tau = params(1);
sa        = params(2);
ca        = params(3);
Delta     = params(4);

Vx  = y(1);
Vy  = y(2);
Vz  = y(3);
Phi = y(4);

ydot(1,1) = ( omega_tau*sa*Vz - Vx ) / Vy;
ydot(2,1) = ( -omega_tau*ca*Vz - Delta/Vy - Vy ) / (Vy - 1/Vy);
ydot(3,1) = ( omega_tau*ca*Vy - omega_tau*sa*Vx - Vz ) / Vy;
ydot(4,1) = ( ydot(2) - Delta) / Vy;
