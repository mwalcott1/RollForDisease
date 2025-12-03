%% Data loading & plotting
% clear

% load & process data
path = "covid_Singapore.csv";
data = readmatrix(path);
data = data(1:400, :);
% data = data(1:327, :); % clean data if us
dates = data(:, 1);
infected = data(:, 2) - data(:, 3) - data(:,4);
recovered = data(:, 3);
deaths = data(:, 4);

% plot data
figure
hold on
plot(dates, infected)
plot(dates, recovered)
plot(dates, deaths)
hold off
legend('infected', 'recovered', 'deaths')

%% Parameter estimation

% Starting Values for Parameter Estimates

% Note: these are not the parameters!  These are initial GUESSES to the
% parameters to get the optimization algorithm going.
params = zeros(3,1);

%{
params(1) = 0.2; % beta
params(2) = 0.75; % gamma
params(3) = 1e-5; % delta
%}
params(1) = 0.1;
params(2) = 0.1;
params(3) = 0.1;
% params(4) = 1e-5; % alpha

%Initial conds (variables go in order: s, i, r, d)
pop = 5690000;
x0 = zeros(4,1);
x0(2) = 1; % patient zero
x0(1) = pop; % us population
x0(3) = 0; % no recovered yet
x0(4) = 0; % no deaths yet

% fminsearch (Nelder-Mead Simplex Method)
% options = optimset('Display','iter');
options = optimset('Display','iter','MaxFunEvals',10000, 'MaxIter',10000);
best_params = fminsearch(@(p) ssir_err(dates,x0,p,data(:, 2:4)),params,options);
best_params

%% Use lsqnonlin instead
options = optimoptions('lsqnonlin','Display','iter');
lb = [0,0];  % lower bound of parameters in the order [betaI, betaW, xi, k]
ub = [5,.1];  % upper bound of parameters
best_params = lsqnonlin(@(p) ssir_lsq(dates,x0,p,data(:, 2:4)), params,lb,ub,options);
best_params

%% Re-simulate the model with the final parameter estimates; 
% note that we force the solver to return the solution at points "dates" 
% to be able to compare the data with the solution

[dates,y] = ode45(@(t,x)ssirODE(t,x,best_params),dates,x0);

% Plot the model results alongside the actual data
figure
hold on
plot(dates, infected)
plot(dates, recovered)
plot(dates, deaths)
% plot(dates, y(:, 1),'--')
plot(dates, y(:, 2), '--') % Infected
plot(dates, y(:, 3), '--') % Recovered
plot(dates, y(:, 4), '--') % Deaths
hold off
legend('cases', 'recovered', 'deaths', 'model infected', 'model recovered', 'model deaths');