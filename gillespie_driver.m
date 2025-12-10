N_TOTAL=3000; %Total population
INITIAL_INFECTED=500; %Initial number of infected
N_TRIALS=25; %Number of times simulation will be ran
T_FINAL=100; %Ending time for simulation
ALPHA=0.25;
BETA=0.5;
GAMMA=0.1;
DELTA=0.005;

USE_GAMMA_PRIOR=false; %Set to true to resample beta for each simulation
SHAPE=1;
SCALE=1;

figure
hold on

params=struct("alpha",ALPHA,"beta",BETA,"gamma",GAMMA,"delta",DELTA,"N",N_TOTAL);

for n=1:N_TRIALS

    % TODO
    % incorrect gamma prior implementation
    % this samples beta from our prior once at the beginning and then uses 
    % that beta for the whole path/trial. what we need to do is sample beta
    % from our prior at each timestep of a path
    % see also: gillespie_SIRD.m
    if(USE_GAMMA_PRIOR)
        params.beta=icdf("Gamma",rand,SHAPE,SCALE);
    end
    tspan = [0,T_FINAL];
    % Initial conditions: [Susceptible; Infected; Recovered; Deceased]
    y0 = [N_TOTAL-INITIAL_INFECTED; INITIAL_INFECTED; 0; 0]; 
    [t,y]=gillespie_SIRD(tspan,y0,params);
    p1=plot(t,y(:,1),"Color","r"); %For the Gamma prior, this plot can
    p2=plot(t,y(:,2),"Color","g"); % be difficult to read
    p3=plot(t,y(:,3),"Color","b");
    p4=plot(t,y(:,4),"Color","k");
    if(n==1)
        p = [p1, p2, p3, p4]; 
    end

    % TODO:
    % 1. bump up the number of trials HELLA. takes a couple minutes for 25
    % samples on curio's laptop, so judge accordingly, but the more samples 
    % we can get the better
    % 2. for each trial, capture infected pop y(:,2) at certain timesteps;
    % probably around 10, 50, 100?
    % 2.5 find some way to export this data out of matlab
    % 3. after simulation is run, create overlaid histograms/densities of 
    % this infected population at these timesteps
    % 4. repeat this process for bayes so we can compare, say, the density
    % of our infected pop at t=50 for a bayes approach and standard
    % stochastic approach
end
plot(t,0)
ylabel("Population")
xlabel("Time")
legend(p,{"S","I","R","D"})
title("Stochastic SIRD Population Over Time")
hold off

