function E = ssir_lsq(tspan,y0,params,data)
% This file defines the residual vector for optimizing OLS with lsqnonlin
% inputs data to solve the model
% outputs the residuals as a VECTOR (error at each point) for use with lsqnonlin

% Given specific parameter estimates, generate simulated data 
pop = 5690000;
% y0(2) = 1;
% y0(1) = pop-y0(2);
y0(2) = data(1, 2)*params(5);   % reporting rate "k" affects initial condition
% y0(1) = 1-y0(2);
[t,y] = ode45(@(t,x) ssirODErescaled(t,x,params),tspan,y0);
% model = y(:,2)/params(5);        % model solution for data comparison
y(:,2) = y(:,2)/params(5); % reporting rate

% model_I = y(:,2);

model_ID = y(:, [2, 4]);
model_ID = reshape(model_ID, [], 1);

% data_I = data(:, 2);

data_ID = data(:, [2, 4]);
data_ID = reshape(data_ID, [], 1);

E = data_ID - model_ID;  % residual vector: exact minus approx, as a vector
% E = sqrt(abs(E));
end