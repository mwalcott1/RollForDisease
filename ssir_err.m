function err = ssir_err(tspan,y0,params,data)
% This file defines the penalty function for the optimization
% inputs data to solve the model
% outputs the error as a SCALAR for use with fminsearch
% there are many options to define the error, choose from below

% Given specific parameter estimates, generate simulated data 
pop = 5690000;
% y0(2) = data(1)*params(5);   % reporting rate "k" affects initial condition
% y0(1) = 1-y0(2);
% y0(2) = 1;
% y0(1) = pop-y0(2);
[t,y] = ode45(@(t,x) ssirODErescaled(t,x,params),tspan,y0);

%% Specify your objective function to be minimized
%  Note that you can apply ordinary least squares (OLS) using weights =  ones

% weights = ones(length(data),1);   % OLS
% weights = 1./(mean(data) + 1);            % RWLS, added one in denom to avoid division by zero
% weights = ones(length(data),1);   % GWLS
% weights(2) = 0;
% weights(3) = 0;
% weights = 1./log(data); % Own
%err = sum((data-y).^2.*weights);  % objective function
% size(data)
% size(y)

y_justID = y(:,[2,4]);
data_justID = data(:,[2,4]);
err = norm(y_justID - data_justID);

% err = norm(data - y, 2);

% ensure nonnegative params
%{
if(params(1) < 0 || params(2) < 0 || params(3) < 0 || params(4) < 0)
    %err = 1e10;
end
%}