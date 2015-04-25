%% simulation.m
clear; close all; clc;
addpath(genpath('../'));

%% Get initial states, parameters (controller gains, etc.)
pars = GetParameters();

% ts = linspace(pars.t0, pars.T, pars.dt);
ts = pars.t0:pars.dt:pars.T;
nsteps = length(ts);

%% Define the initial state x and control inputs u
x = pars.x0;    % [beta; r; U_x]
u = pars.u0;    % [delta; F_xR]

%% Store state, control inputs
Pos = NaN(3,nsteps);
dX  = NaN(3,nsteps);
X   = NaN(3,nsteps);
U   = NaN(2,nsteps);

%% Run simulation
for t = 1:nsteps
    if t == 1237
        aaa = 0;
    end
    %% Get control inputs
    u_plus = Controller(x,u,pars); % Compute control inputs u

    %% Compute dynamics
    dx_plus = Dynamics(x,u_plus,pars); % Compute state x after control inputs u
    
    if (norm(imag(u_plus)) > 0)
        error('Complex control input')
    elseif (norm(imag(dx_plus)) > 0)
        error('Complex integrated dynamics');
    end
        
    x_plus = IntegrateDynamics(dx_plus,x,pars.dt);

    %% Display
%     DisplayCar(x_plus,u_plus,pars);
    
    %% Update and save the states
    dx = dx_plus;
    x = x_plus;
    u = u_plus;

    dX(:,t) = dx_plus;
    X(:,t) = x_plus;
    U(:,t) = u_plus;
    fprintf('t = %f\n', t);

end

figure; hold on;
plot(t, X(1,:)*180/pi, 'b');
plot(t, ones(length(nsteps), 1)*pars.beta_eq*180/pi, 'g');






