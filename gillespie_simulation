function trials = gillespie_simulation(params) 
N_TOTAL=params.nTotal; %Total population
INITIAL_INFECTED=params.initialInfected; %Initial number of infected
N_TRIALS=params.nTrials; %Number of times simulation will be ran
T_FINAL=params.tFinal; %Ending time for simulation
ALPHA=params.alpha;
BETA=params.beta;
GAMMA=params.gamma;
DELTA=params.delta;

USE_GAMMA_PRIOR=params.useGammaPrior; %Set to true to resample beta for each simulation
SHAPE=params.gammaShape;
SCALE=params.gammaScale;

params2=struct("alpha",ALPHA,"beta",BETA,"gamma",GAMMA,"delta",DELTA,"N",N_TOTAL);

for n=1:N_TRIALS
    if(USE_GAMMA_PRIOR)
        params2.beta=icdf("Gamma",rand,SHAPE,SCALE);
    end
    tspan = [0,T_FINAL];
    y0 = [N_TOTAL-INITIAL_INFECTED; INITIAL_INFECTED; 0; 0]; 
    [t,y]=gillespie_SIRD(tspan,y0,params2);
    
    trials(n) = struct("y",y,"t",t);
end

