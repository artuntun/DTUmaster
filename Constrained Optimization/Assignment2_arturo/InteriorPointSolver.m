function [xk, iterations,zk] = InteriorPointSolver(H, g, C, d, x0)
    [m,n] = size(C);
    %%Initialize the problem 
    z0 = ones(m,1); %must be >0
    s0 = ones(m,1); %must be >0
    lenx = length(x0); lenz=length(z0); 
    xk = x0; zk = z0; sk = s0;
    rL = H*xk + g - C'*zk;
    rC = C*xk + sk + d;
    rSZ = diag(sk)*diag(zk)*ones(length(zk),1);

    STOP = false;
    itermax = 30;
    iterations = 0;
    while STOP==false && iterations < itermax
        iterations = iterations + 1;

        %Duality measurment
        mu = sum(rSZ)/length(rSZ);
        Fkplusmu = [rL; rC; rSZ+mu];
     
        %%Jacobian update
        J =[H -C' zeros(n,m); 
        C zeros(m) eye(m);
        zeros(m,n)  diag(sk) diag(zk)];

        %%Biased Newton's step
        step = J\-Fkplusmu;
        dx = step(1:lenx);
        dz = step(lenx+1:lenx+lenz);
        ds = step(lenx+lenz+1:end);

        %%Maximum alpha wich mantain si*zi>=0
        if [dz;ds] >= 0
            alpha = 1;
        else
            [val, index] = min([dz;ds]);
            zksk = [zk;sk];
            alpha_k = -zksk(index)/val;
            alpha = min(1,alpha_k); 
        end;
        alpha = 0.80*alpha;

        %%stepping
        xk = xk + alpha*dx
        zk = zk + alpha*dz;
        sk = sk + alpha*ds;

        %%Update residuals
        %xk = x0; zk = z0; sk = s0;
        rL = H*xk + g - C'*zk;
        rC = C*xk + sk + d;
        rSZ = diag(sk)*diag(zk)*ones(length(zk),1);
        Fk = [rL ;rC ;rSZ];
        
        %%Check convergence
        if Fk <= 0.005
            STOP = true;
        end
    end
end


