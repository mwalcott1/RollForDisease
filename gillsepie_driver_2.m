N_TOTAL=3000; 
INITIAL_INFECTED=500; 
N_TRIALS=25; 
T_FINAL=100; 
ALPHA=0.25;
BETA=0.5;
GAMMA=0.1;
DELTA=0.005;

USE_GAMMA_PRIOR = true;
SHAPE = 1;
SCALE = 1;

figure
hold on

params = struct("alpha",ALPHA,"beta",BETA,"gamma",GAMMA,"delta",DELTA,"N",N_TOTAL);


capture_times = [10, 50, 100];
num_capture_times = length(capture_times);

infected_capture = zeros(N_TRIALS, num_capture_times);


for n = 1:N_TRIALS

    if (USE_GAMMA_PRIOR)
        params.beta = icdf("Gamma",rand,SHAPE,SCALE); 
    end

    tspan = [0, T_FINAL];
    y0 = [N_TOTAL - INITIAL_INFECTED; INITIAL_INFECTED; 0; 0];

    [t,y] = gillespie_SIRD_2(tspan, y0, params, USE_GAMMA_PRIOR, SHAPE, SCALE);

    for k = 1:num_capture_times
        infected_capture(n, k) = interp1(t, y(:,2), capture_times(k));
    end


    p1 = plot(t,y(:,1),"Color","r");
    p2 = plot(t,y(:,2),"Color","g");
    p3 = plot(t,y(:,3),"Color","b");
    p4 = plot(t,y(:,4),"Color","k");

    if (n == 1)
        p = [p1, p2, p3, p4];
    end
end

plot(t,0)
ylabel("Population")
xlabel("Time")
legend(p,{"S","I","R","D"})
title("Stochastic SIRD Population Over Time")
hold off

% ============================================================
% Export to CSV for R
for k = 1:num_capture_times
    fname = sprintf("infected_t%d.csv", capture_times(k));
    writematrix(infected_capture(:, k), fname);
end

disp("CSV export complete: infected_t10.csv, infected_t50.csv, infected_t100.csv");
% ============================================================

