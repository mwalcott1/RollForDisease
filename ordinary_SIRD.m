function [t,y] = ordinary_SIRD(t,y0,params)
    y(1,:)=y0;
    ycur=y0;
    n = 1;
    tLast = 0;
    for i = t
       dt=0;
       if(n ~= 1)
           dt = i - tLast;
       end
       tLast = i;
       if(n == 1 || n == length(t))
           n = n + 1;
           continue
       end
        n = n + 1;

       deltaY = [
           -params.beta .* ycur(1) .* ycur(2) ./ params.N + params.alpha .* ycur(3);
           params.beta .* ycur(1) * ycur(2) ./ params.N - params.gamma .* ycur(2) - params.delta .* ycur(2);
           params.gamma .* ycur(2) - params.alpha .* ycur(3);
           params.delta .* ycur(2);
       ];
       



        ycur = ycur + dt .* deltaY;

       y(n,:)=ycur;
    end
end
