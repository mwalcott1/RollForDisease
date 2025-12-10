N_TOTAL=5690; 
INITIAL_INFECTED=683; 
N_TRIALS=1000; 
T_FINAL=50; 
ALPHA=0.0266;
BETA=1.4647;
GAMMA=1.3548;
DELTA=2.5086e-5;

figure
hold on

params = struct("alpha",ALPHA,"beta",BETA,"gamma",GAMMA,"delta",DELTA,"N",N_TOTAL);


capture_times = [1.6, 5, 10];
num_capture_times = length(capture_times);

infected_capture = zeros(N_TRIALS, num_capture_times);

tspan = [0, T_FINAL];
y0 = [N_TOTAL - INITIAL_INFECTED; INITIAL_INFECTED; 240; 3];



for j = 1:2
    for n = 1:N_TRIALS
        if (j == 2)
            USE_GAMMA_PRIOR=true;
            SHAPE = 2.5;
            SCALE = 1/1.4647;
        else
            USE_GAMMA_PRIOR=false;
        end
        
        if (USE_GAMMA_PRIOR)
            params.beta = icdf("Gamma",rand,SHAPE,SCALE); 
        end
    
        [t,y] = gillespie_SIRD_2(tspan, y0, params, USE_GAMMA_PRIOR, SHAPE, SCALE);
    
        for k = 1:num_capture_times
            infected_capture(n, k) = interp1(t, y(:,2), capture_times(k));
        end
        
        if (j == 2)
            p5 = plot(t,y(:,2),"Color","r");
            p5.Color(4) = 0.1;
        else
            p2 = plot(t,y(:,2),"Color","g");
            p2.Color(4) = 0.1;
        end
        %{
        p1 = plot(t,y(:,1),"Color","r"); %suscept
        p1.Color(4) = 0.25;
        p3 = plot(t,y(:,3),"Color","b"); %recovery
        p3.Color(4) = 0.25;
        p4 = plot(t,y(:,4),"Color","k"); %deaths
        p4.Color(4) = 0.25;
        %}
    
        if (j == 2)
            p = [p2, p5];
        end
    end
end



ylabel("Population")
xlabel("Time")
%legend(p,{"S","I","R","D"})
title("ODE vs. Plain Stochastic vs. Bayesian Approach")
xlim([0,20])
ylim([0,3000])

% ODE model for comparison

best_params = [BETA, GAMMA, DELTA, ALPHA];
dates = linspace(0,50,100).';
[dates,y2] = ode45(@(t,x)ssirODE(t,x,best_params),dates,y0);

%plot(dates, y2(:, 1),'--') % Susceptible
p6 = plot(dates, y2(:, 2),'b-',"LineWidth",1.5); % Infected
%plot(dates, y2(:, 3), '--',LineWidth=1.5) % Recovered
%plot(dates, y2(:, 4), '--') % Deaths
legend([p, p6],{"ODE","Plain","Bayes"})
hold off

%% ============================================================
% Export to CSV for R
for k = 1:num_capture_times
    fname = sprintf("infected_t%d.csv", capture_times(k));
    writematrix(infected_capture(:, k), fname);
end

disp("CSV export complete: infected_t10.csv, infected_t50.csv, infected_t100.csv");
% ============================================================

