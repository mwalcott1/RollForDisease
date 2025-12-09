nTotal=3000; %Total population
initialInfected=500; %Initial number of infected
nTrials=5; %Number of times simulation will be ran
tFinal=100; %Ending time for simulation
alpha=0.0266;
beta=1.4662;
gamma=1.3561;
delta=0.0001;

useGammaPrior=true; %Set to true to resample beta for each simulation
shapeFactor= 10;
gammaShape=shapeFactor;
gammaScale=beta/shapeFactor;

figure("Visible","on")
hold on

params=struct("nTotal", nTotal,"initialInfected", initialInfected,"nTrials", nTrials,"tFinal", tFinal,"alpha",alpha, "beta",beta, "gamma",gamma,"delta",delta,"useGammaPrior",useGammaPrior,"gammaShape",gammaShape,"gammaScale",gammaScale);
trials=gillespie_simulation(params);

patchWrapper = @(x, y, lw,c, a) patch(x, y, c, ...
    'LineWidth', lw, ...
    'FaceColor', 'none', ...
    'EdgeAlpha', a);

%gillespie plot
for n=1:length(trials)
    
    t=trials(n).t;
    y=trials(n).y;

    p1=plot(t,y(:,1),"LineWidth",0.1,"Color",[1,0.66,0.66]); %For the Gamma prior, this plot can
    p2=plot(t,y(:,2),"LineWidth",0.1,"Color",[0.66,1,0.66]); % be difficult to read
    p3=plot(t,y(:,3),"LineWidth",0.1,"Color",[0.66,0.66,1]);
    p4=plot(t,y(:,4),"LineWidth",0.1,"Color",[0.66,0.66,0.66]);

    if(n==1)
        p = [p1, p2, p3, p4]; 
    end
end

%mean curve
% mean = zeros(4,length(t));
% mean(1,:) = mean([trials.y], 1);
% mean(2,:) = mean([trials.y], 2); 
% mean(3,:) = mean([trials.y], 3);
% mean(4,:) = mean([trials.y], 4);

% plot(t,mean)

%non-stochastic curve
params2=struct("alpha",alpha,"beta",beta,"gamma",gamma,"delta",delta,"N",nTotal);

[t,y] = ordinary_SIRD(trials(1).t,[N_TOTAL-INITIAL_INFECTED; INITIAL_INFECTED; 0; 0],params2);

plot(t,y(:,1),"Color","r","LineStyle","--","LineWidth",1); 
plot(t,y(:,2),"Color","g","LineStyle","--","LineWidth",1);
plot(t,y(:,3),"Color","b","LineStyle","--","LineWidth",1);
plot(t,y(:,4),"Color","k","LineStyle","--","LineWidth",1);

plot(t,0)
ylabel("Population")
xlabel("Time")
legend(p,{"S","I","R","D"})
title("Stochastic SIRD Population Over Time")

hold off
figure 
hold on 

for n=1:length(triathels)
% other plot
end

hold off
