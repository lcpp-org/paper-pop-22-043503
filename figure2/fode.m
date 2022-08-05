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

ydot(1,1) = ( -omega_tau*ca*Vz - Delta/Vx - Vx ) / (Vx - 1/Vx);
ydot(2,1) = ( omega_tau*sa*Vz - Vy ) / Vx;
ydot(3,1) = ( omega_tau*ca*Vx - omega_tau*sa*Vy - Vz ) / Vx;
ydot(4,1) = ( ydot(1) - Delta) / Vx;
