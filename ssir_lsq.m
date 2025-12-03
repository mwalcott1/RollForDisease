function E = ssir_lsq(tspan,y0,params,data)
% This file defines the residual vector for optimizing OLS with lsqnonlin
% inputs data to solve the model
% outputs the residuals as a VECTOR (error at each point) for use with lsqnonlin

% Given specific parameter estimates, generate simulated data 
pop = 5690000;
y0(2) = 1;
y0(1) = pop-y0(2);
[t,y] = ode45(@(t,x) ssirODE(t,x,params),tspan,y0);
model = y(:,2:4);        % model solution for data comparison

E = norm(data - model, 2);  % residual vector: exact minus approx, as a vector
end