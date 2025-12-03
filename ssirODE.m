function dxdt = ssirODE(t,x,params)
%model equations for simulating the scaled SIWR model
%x(1) = susceptibles s
%x(2) = infecteds i
%x(3) = recovered
%x(4) = dead

pop = 5690000;

beta = params(1);
gamma = 0.1;          % do not estimate gamma
delta = params(2);
alpha = 1/105; % do not estimate alpha

dxdt = zeros(4,1); %column vector for the state variables
dxdt(1) = -beta*x(1)*x(2)/(pop - x(4)) + alpha*x(3);
dxdt(2) = beta*x(1)*x(2)/(pop - x(4)) - gamma*x(2) - delta*x(2);
dxdt(3) = gamma*x(2) - alpha*x(3);
dxdt(4) = delta*x(2);
end