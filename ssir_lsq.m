function E = ssir_lsq(tspan,y0,params,data)
% This file defines the residual vector for optimizing OLS with lsqnonlin
% inputs data to solve the model
% outputs the residuals as a VECTOR (error at each point) for use with lsqnonlin

% Given specific parameter estimates, generate simulated data 
pop = 5690000;
% y0(2) = 1;
% y0(1) = pop-y0(2);
% y0(2) = data(1)*params(5);   % reporting rate "k" affects initial condition
% y0(1) = 1-y0(2);
[t,y] = ode45(@(t,x) ssirODErescaled(t,x,params),tspan,y0);
% model = y(:,2)/params(5);        % model solution for data comparison
model = y(:, 2)

E = data(:, 2) - model;  % residual vector: exact minus approx, as a vector
end