%% Data loading & plotting
clear

% load & process data
path = "cleanedData/covid_Singapore.csv";
data = readmatrix(path);
data = data(70:200, :); % truncate to only days 70 - 200
% data = data(1:327, :); % clean data if us
dates = data(:, 1);
infected = data(:, 2) - data(:, 3) - data(:,4);
recovered = data(:, 3);
deaths = data(:, 4);

pop = 5690000;

% processed data = [susceptible, inf, rec, dead]
processed_data = [pop - infected - recovered - deaths, infected, recovered, deaths];

%% plot data
figure
hold on
plot(dates, infected)
plot(dates, recovered)
plot(dates, deaths)
hold off
legend('infected', 'recovered', 'deaths')

%% rescale data
processed_data = processed_data/pop;
infected = processed_data(:, 2);
recovered = processed_data(:, 3);
deaths = processed_data(:, 4);

%% Set up parameter estimation

% Starting Values for Parameter Estimates

% Note: these are not the parameters!  These are initial GUESSES to the
% parameters to get the optimization algorithm going.
params = zeros(4, 1);


params(1) = 1.8; % beta
params(2) = 1.7; % gamma
params(3) = 1e-4; % delta
params(4) = 1/105; % alpha
params(5) = 1e-2; % reporting rate k

%Initial conds (variables go in order: s, i, r, d)
x0 = zeros(4,1);
x0(2) = infected(1);

x0(3) = recovered(1); % no recovered yet
x0(4) = deaths(1); % no deaths yet
x0(1) = 1 - x0(2) - x0(3) - x0(4); % us population

%% fminsearch (Nelder-Mead Simplex Method)
% don't use this for now
%{
% options = optimset('Display','iter');
options = optimset('Display','iter','MaxFunEvals',10000, 'MaxIter',10000);
best_params = fminsearch(@(p) ssir_err(dates,x0,p,processed_data),params,options);
best_params
%}

%% Use lsqnonlin instead

options = optimoptions('lsqnonlin','Display','iter');
lb = [0,0,0,0,0];  % lower bound of parameters in the order
% ub = [,.5,.8,1,.5];  % upper bound of parameters
best_params = lsqnonlin(@(p) ssir_lsq(dates,x0,p,processed_data), params,lb,[],options);
best_params

%% Re-simulate the model with the final parameter estimates; 
% note that we force the solver to return the solution at points "dates" 
% to be able to compare the data with the solution

%best_params = [1.8367,1.7152,0.0001,0.0603];

[dates,y] = ode45(@(t,x) ssirODErescaled(t,x,best_params), dates, x0);

% Plot the model results alongside the actual data
figure
hold on
plot(dates, infected)
plot(dates, recovered)
plot(dates, deaths)
%plot(dates, y(:, 1),'--') % Susceptible
plot(dates, y(:, 2)/(best_params(5)), '--') % Infected
plot(dates, y(:, 3), '--') % Recovered
plot(dates, y(:, 4), '--') % Deaths
hold off
legend('infected', 'recovered', 'deaths', 'model infected', 'model recovered', 'model deaths');

%{
for i = 1:130
    totalPeople = y(i, 1) + y(i, 2) + y(i, 3) + y(i, 4);
    if(abs(totalPeople - pop) > 1e-5)
        display("Uh Oh");
    end
end
%}

%% Calculate error landscape

% estimated parameters from literature
gamma = 0.1;
alpha = 1/105;

% set up parameter values 
beta_vec = linspace(0.11, 0.15, 500);
delta_vec = linspace(0, 1e-3, 100);
errorLandscape = zeros(length(beta_vec), length(delta_vec));

i = 1;
for beta = beta_vec
    j = 1;
    for delta = delta_vec
        params_plt = [beta, gamma, delta, alpha];
        err = norm(ssir_lsq(dates, x0, params_plt, processed_data));
        errorLandscape(i, j) = err; 
        j = j + 1;
    end
    i = i + 1;
end

%% Plot error landscape

% Create a surface plot for the error landscape
figure;
imagesc(beta_vec, delta_vec, errorLandscape')   % X and Y axis mapped to vectors
set(gca,'YDir','normal')                         % imagesc defaults to inverted y
colormap(parula)                                % or hot, jet, viridis, etc.
colorbar
xlabel('Beta');
ylabel('Delta');
zlabel('Error');
title('Error Landscape for Parameter Estimation');
colorbar;