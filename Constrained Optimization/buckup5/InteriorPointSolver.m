function [finalState, iterations, alpha] = InteriorPointSolver(H, g, A, b, C, d, x0)
    [ma,na] = size(A);
    [mc,nc] = size(C);
    %%Initialization.   
    y0 = ones(na,1);
    z0 = ones(nc,1); %must be >0
    s0 = ones(nc,1); %must be >0
    lenx = length(x0); leny = length(y0); lenz=length(z0);
    xk = x0; yk = y0; zk = z0; sk = s0;
    rL = H*xk + g - A*yk - C*zk;
    rA = -A'*xk + b;
    rC = -C'*xk + sk + d;
    rSZ = diag(sk)*diag(zk)*ones(length(zk),1);

    STOP = false;
    itermax = 1000;
    iterations = 0;
    while STOP==false && iterations < itermax
        iterations = iterations + 1;

        %Duality measurment
        mu = sum(rSZ)/length(rSZ);
        Fkplusmu = [rL; rA; rC; rSZ+mu];
     
        %%Jacobian update
        J =[H -A -C zeros(mc); 
        -A' zeros(na) zeros(na,nc) zeros(na,mc);
        -C' zeros(nc,na) zeros(nc) eye(mc);
        zeros(mc,ma) zeros(mc, na) diag(sk) diag(zk)];

        %%Biased Newton's step
        step = J\-Fkplusmu;
        dx = step(1:lenx);
        dy = step(lenx+1: lenx+leny);
        dz = step(lenx+leny+1:lenx+leny+lenz);
        ds = step(lenx+leny+lenz+1:end);

        %%Maximum alpha wich mantain si*zi>=0
        if [dz;ds] >= 0
            alpha = 1;
        else
            [val, index] = min([dz;ds]);
            zksk = [zk;sk];
            alpha_k = -zksk(index)/val;
            alpha = min(1,alpha_k); 
        end;
        alpha = 0.55*alpha;

        %%stepping
        xk = xk + alpha*dx;
        yk = yk + alpha*dy;
        zk = zk + alpha*dz;
        sk = sk + alpha*sk;

        %%Update residuals
        rL = H*xk + g - A*yk - C*zk;
        rA = -A'*xk + b;
        rC = -C'*xk + sk + d;
        rSZ = diag(sk)*diag(zk)*ones(length(zk),1);
        Fk =[rL; rA; rC; rSZ];
        
        %%Check convergence
        if Fk <= 0.0005
            STOP = true;
        end
        %         pause;
    end
    finalState = [xk;yk;zk;sk];
end


