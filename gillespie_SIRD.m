function [t,y] = gillespie_SIRD(tspan,y0,params)
    t0=tspan(1);
    tf=tspan(2);
    t(1)=t0;
    y(1,:)=y0;
    tcur=t0;
    ycur=y0;
    i=1;
    while (tcur<tf)
        if (ycur(2)==0)
            i=i+1;
            t(i)=tf;
            y(i,:)=ycur;
            break;
        end
        

        % todo: implement bayes functionality here, where the beta param
        % is instead sampled from Gamma(r,s)
       infRate=params.beta*ycur(1)*ycur(2)/params.N;
       deathRate=params.delta*ycur(2);
       immunityLossRate=params.alpha*ycur(3);
       recRate=params.gamma*ycur(2);
       totRate=infRate+deathRate+recRate+immunityLossRate;

       dt=-1/totRate*log(rand);
       tcur=tcur+dt;
       infection=(rand<(infRate/totRate));
       death=(rand<(deathRate/totRate));
       immuneLoss=(rand<(immunityLossRate/totRate));
       recovery=(rand<(recRate/totRate));

        if(infection)
            ycur(1) = ycur(1) - 1; 
            ycur(2) = ycur(2) + 1; 
        end
        if(death)
            ycur(2) = ycur(2) - 1;
            ycur(4) = ycur(4) + 1;
        end
        if(immuneLoss)
            ycur(3) = ycur(3) - 1; 
            ycur(1) = ycur(1) + 1;
        end
        if(recovery)
            ycur(2) = ycur(2) - 1; 
            ycur(3) = ycur(3) + 1; 
        end

       i=i+1;
       t(i)=tcur;
       y(i,:)=ycur;
    end
end
