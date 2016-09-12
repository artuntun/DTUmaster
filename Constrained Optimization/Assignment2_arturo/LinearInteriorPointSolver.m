function [x, s, lambda, iter] = LinearInteriorPointSolver(C, A, b, x)
% LPIPPD   Primal-Dual Interior-Point LP Solver
%
%          min  C'*x
%           x
%          s.t. A x  = b      (Lagrange multiplier: mu)
%                 x >= 0      (Lagrange multiplier: lamba)
%
% Syntax: [x,info,mu,lambda,iter] = LPippd(C,A,b,x)
%
%         info = true   : Converged
%              = false  : Not Converged

% Created: 14.05.2016
% Author : Arturo Arranz Mateo
%          Constrained Optimization, Technical University of Denmark

[m,n] = size(A);                    %m = number constraints 
                                    %n = number of variables
                                    

eta = 0.99; 
maxiter = 50;
tolL = 1.0e-9;
tolA = 1.0e-9;
tols = 1.0e-9;
s = ones(n,1); 
lambda=ones(m,1);   
% ex = A'*(A*A')^-1*b;
% deltx = max((-3/2)*min(ex),0);
% x = ex+deltx;
%%Initialize the problem                      
rc = A'*lambda + s - C;             %Lagrangian gradient
rb = A*x - b;                       %Constraints
rSZ = x.*s;                         %Complementary           
mu = sum(rSZ)/n;                    %Duality measurment
Fk = [rc; rb; rSZ];                 %right-hand side system

%%Converged
Converged = (norm(rc,inf) <= tolL) && ...
        (norm(rb,inf) <= tolA) && ...
        (abs(mu) <= tols);
 
iter = 0;
while ~Converged && (iter<maxiter)
    iter = iter + 1;
    
    % ================================================
    % Solving Affine Step
    % ================================================
    %%Jacobian update
    J =[zeros(n) A' eye(n); 
    A 0 zeros(m,n);
    diag(s)  zeros(n,m) diag(x)];

    %%Affine step
    stepAffi = J\-Fk;
    dx = stepAffi(1:length(x));
    dlambda = stepAffi(length(x)+1:length(x)+length(lambda));
    ds = stepAffi(length(x)+length(lambda)+1:end);

    % ================================================
    % Maxium affine length step
    % ================================================
    %max affine step before violating nonnegativity
    idx = find(dx < 0.0);
    alphaMaxPri = min(-x(idx)/dx(idx));
    ids = find(ds < 0.0);
    alphaMaxDual = min(-s(ids)/ds(ids));
    alphaPri = min(1.0, alphaMaxPri);
    alphaDual = min(1.0, alphaMaxDual);
    
    % ================================================
    % Centering paramter & Predictor-Corrector Step length
    % ================================================
    muAff = (x+alphaPri.*dx)'*(s+alphaDual*ds)/n;
    sigma = (muAff/mu)^3;
    tau = sigma*mu;

    %predictor-corrector step
    predCorrStep = J\(-Fk+[zeros(n,1);zeros(m,1);-dx.*ds + tau]);
    dx = predCorrStep(1:length(x));
    dlambda = predCorrStep(length(x)+1:length(x)+length(lambda));
    ds = predCorrStep(length(x)+length(lambda)+1:end);

    idx = find(dx < 0.0);
    alphaMaxPri = min(-x(idx)/dx(idx));
    ids = find(ds < 0.0);
    alphaMaxDual = min(-s(ids)/ds(ids));
    alphaPri = min(1.0, alphaMaxPri);
    alphaDual = min(1.0, alphaMaxDual);
    if(length(alphaDual)>1)
        alphaDual = alphaDual(1);
    end
    if(length(alphaPri)>1)
        alphaPri = alphaPri(1);
    end
    % ================================================
    % Take Step
    % ================================================
    x = x + eta*alphaPri*dx;
    lambda = lambda + eta*alphaDual*dlambda;
    s = s + eta*alphaDual*ds;
    % ====================================================================
    % Residuals and Convergence
    % ====================================================================
    % Compute residuals
    rc = A'*lambda + s - C;             % Lagrangian gradient
    rb = A*x - b;                       % Constraints
    rSZ = x.*s;                    % Complementarity
    mu = sum(rSZ)/n;                    % Duality gap

    % Converged
    Converged = (norm(rc,inf) <= tolL) && ...
                (norm(rb,inf) <= tolA) && ...
                (abs(mu) <= tols);
%     
%     pause;
end


