function [t,y] = gillespie_SIRD_2(tspan, y0, params, USE_GAMMA_PRIOR, SHAPE, SCALE)

    t0 = tspan(1);
    tf = tspan(2);

    t(1) = t0;
    y(1,:) = y0;

    tcur = t0;
    ycur = y0;
    i = 1;

    while (tcur < tf)

        if ycur(2) == 0
            i = i + 1;
            t(i) = tf;
            y(i,:) = ycur;
            break;
        end

        if USE_GAMMA_PRIOR
            beta_now = gamrnd(SHAPE, SCALE);
        else
            beta_now = params.beta;
        end

        infRate          = beta_now * ycur(1) * ycur(2) / params.N;
        deathRate        = params.delta * ycur(2);
        immunityLossRate = params.alpha * ycur(3);
        recRate          = params.gamma * ycur(2);

        totRate = infRate + deathRate + recRate + immunityLossRate;

        if totRate <= 0
            break;
        end

     
        dt = -log(rand) / totRate;
        tcur = tcur + dt;

       
        infection   = (rand < infRate          / totRate);
        death       = (rand < deathRate        / totRate);
        immuneLoss  = (rand < immunityLossRate / totRate);
        recovery    = (rand < recRate          / totRate);


        if infection
            ycur(1) = ycur(1) - 1;
            ycur(2) = ycur(2) + 1;
        elseif death
            ycur(2) = ycur(2) - 1;
            ycur(4) = ycur(4) + 1;
        elseif immuneLoss
            ycur(3) = ycur(3) - 1;
            ycur(1) = ycur(1) + 1;
        elseif recovery
            ycur(2) = ycur(2) - 1;
            ycur(3) = ycur(3) + 1;
        end


        i = i + 1;
        t(i) = tcur;
        y(i,:) = ycur;
    end
end
