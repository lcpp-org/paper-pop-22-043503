%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% R. Khaziev, D. Curreli, Ion energy-angle distribution functions at 
% the plasma-material interface in oblique magnetic fields, 
% Physics of Plasmas, Vol. 22, Is. 4, 043503 (2015)
% 
% https://doi.org/10.1063/1.4916910 
% 
% Description. Matlab script for the generation of formatted Figure 2
% in the paper.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

clear all
close all
D2R = pi/180;

% Ion Hall parameter, omega*tau
%   1e-3     Earth's magnetopause
%   0.1-1.0  Magnetron Discharges
%   1e6      Tokamak Discharges
omega_tau = 100;

% Magnetic field angle 'alpha' [rad]
%  alpha = 0  :  B-field tangent to the surface
%  alpha = 90 :  B-field normal to the surface
alfa = 30 * D2R ;
psi  = 90 - alfa/D2R;
sa   = sin(alfa);
ca   = cos(alfa);

% Delta parameter 
% Ionization ratio, ionization frequency / momentum collision frequency
Delta = 1.0;

% Initial conditions 
Vx0   =  0.0;
Vy0   =  1.0e-6;
Vz0   =  0.0;
Phi0  =  0.0;
y0 = [ Vx0; Vy0; Vz0; Phi0 ];

% Domain. Note it is set larger than necessary, integration will stop 
% sooner, at the location where the perpendicular component of the ion
% flow velocity is equal to the Bohm acoustic speed.
xspan = [0 100];

% Parameters 
params(1) = omega_tau;
params(2) = sa; 
params(3) = ca; 
params(4) = Delta;

% ODE options 
options = odeset('Events', @vbohm, 'RelTol', 1.0e-5);

% ODE solve
[X,Y] = ode45( @(x,y) fode(x,y,params), xspan, y0, options );

Xmax = max(X);

Vx  = Y(:,1);
Vy  = Y(:,2);
Vz  = Y(:,3);
Phi = Y(:,4);

V_parall = Vx*ca + Vy*sa;
n        = exp(-Phi);

% Velocity at sheath entrance (normalized to Bohm speed Cs):
Velocity_at_SE = [ Vx(end); Vy(end); Vz(end) ];

figure(2)
FontSizeLabels = 22;        %  Size of label numbers
FontSizeParamters = 16;     %  Size of parameters  
FontSizeAxes = 22;          %  Size of Axes font
set(gcf,'defaultaxesfontsize',FontSizeAxes)
set(gcf,'defaultaxesfontname','Arial')
set(gcf,'defaulttextcolor','black')

plot( X, Vx, 'r', 'LineWidth',2.0 )
hold on
plot( X, Vy, 'b', 'LineWidth',2.0 )
plot( X, Vz, 'k', 'LineWidth',2.0 )
plot( X, V_parall, 'g', 'LineWidth',2.0 )
plot( X, Phi, 'Color', [0.0 0.5 0.5], 'LineWidth',2.0 )
plot( X, n,   'Color', [1.0 0.5 0.0], 'LineWidth',1.0 )

% Identify the location of the Chodura Edge (CE)
Max_V_parall = max(V_parall);
if Max_V_parall<1
  fprintf('No Chodura Sheath in this case\n');
else
  X_location = interp1(V_parall, X, 1.0);
  plot( [X_location X_location],[0 2],'k-')
end

% Velocities according to Reference Frame defined in Figure 1 of the paper
legend('Vx','Vy','Vz', 'V_{||}','\Phi','n','Location','NW')

title(['\omega_{ci} \tau_i = ', num2str(omega_tau), ...
        ', \psi = ', num2str(psi), ' deg, \Delta = ', num2str(Delta) ]);

format_text = '%2.2f';
text(Xmax/4, 1.5, ...
      [ '(Vx,Vy,Vz)@SE=(', ...
      num2str(abs(Velocity_at_SE(1)), format_text), ',', ...
      num2str(abs(Velocity_at_SE(2)), format_text), ',', ...
      num2str(abs(Velocity_at_SE(3)), format_text), ')Cs' ], ...
      'FontSize',16)

plot( [0 Xmax],[1 1], 'k-', 'LineWidth', 1.0)
xlim([0 Xmax])
ylim([0 2])
xlabel('Y [ \lambda_{mfp}]')

print('-f2','-dpdf','pop_22_043503_fig2')
