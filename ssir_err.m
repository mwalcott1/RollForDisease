function err = ssir_err(tspan,y0,params,data)
% This file defines the penalty function for the optimization
% inputs data to solve the model
% outputs the error as a SCALAR for use with fminsearch
% there are many options to define the error, choose from below

% Given specific parameter estimates, generate simulated data 
us_pop = 331449281;
y0(2) = data(1);
y0(1) = us_pop-y0(2);
[t,y] = ode45(@(t,x) ssirODE(t,x,params),tspan,y0);
y = y(:,2)/params(2);  % model solution for data comparison

%% Specify your objective function to be minimized
%  Note that you can apply ordinary least squares (OLS) using weights =  ones

weights = ones(length(data),1);   % OLS
% weights = 1./data;                % RWLS
% weights = ones(length(data),1);   % GWLS
% weights(2) = 0;
% weights(3) = 0;
% weights = 1./log(data); % Own
err = sum((data-y).^2.*weights);  % objective function