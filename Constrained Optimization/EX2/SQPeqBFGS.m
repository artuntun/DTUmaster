function [x,info,iter,y,f] = SQPeqBFGS(x0)
% SQPeq1   Solves an equality constrained NLP by the SQP algorithm
%
%   Solves the eqaulity constrained NLP
%
%       min f(x)    s.t. c(x) = 0
%
% Syntax; [x,info,iter,y,f] = SQPeqBFGS(x0)
%
%       obj: [f,df,d2f] = obj(x)
%       con: [c,dc,d2c] = con(x)

tol = 1.0e-6;   % Tolerance
maxit = 100;    % Maximum number of iterations

% Initialize
iter = 0;
x = x0;

% Evaluate function and constraint
[f,df,d2f]=obj(x);
[c,dc,d2c]=cons(x);

% Initialize BFGS
B=eye(size(d2f));

% Number of Lagrange Multipliers
m = size(c,1);
y = zeros(m,1);

% Gradient of Lagrangian
dL = df - dc'*y;  

% Convergence / KKT 1st order conditions
Converged = ( norm(dL,inf) < tol ) && ( norm(c,inf) < tol );


x   % control
f


% ===============================================================
%   Main Loop
% ===============================================================
while ~Converged && (iter < maxit)
    iter = iter + 1;    

%   % Change this with damped BFGS
%     % Compute Hessian matrix: H = d2L = d2f - \sum( y(i)*d2c(:,:,i) )
%     H = d2f;
%     for i=1:m
%        H = H - y(i,1)*d2c(:,:,i); 
%     end
    
    % Solve equality constrained QP
    [p,y] = EQQP(B,df,dc,-c);
    
    
    % Take step
    x = x+p;
    
    % Function evaluation 
    [f1,df1,d2f1]=obj(x);
    [c1,dc1,d2c1]=cons(x);
    
    % Lagrangian gradients (for BFGS)
    dL1 = df1 - dc1'*y;  
    dL0  = df  - dc1'*y;   
        
    
    % Update damped BFGS
    q   = dL1 - dL0;
    
    if p'*q>=0.2*(p'*(B*p))
        th=1;
    else
        th=0.8*(p'*(B*p))/(p'*(B*p)-p'*q);
    end
    r=th*q+(1-th)*(B*p);
    B=B+((r*r')/(p'*r))-((B*p)*(B*p)')/(p'*(B*p));
    
    f   = f1;
    df  = df1;
    d2f = d2f1;
    c   = c1;
    dc  = dc1;
    d2c = d2c1;
    dL = dL1;
    
    % Convergence / KKT 1st order conditions
    Converged = ( norm(dL,inf) < tol ) && ( norm(c,inf) < tol );
    
        x   %control
    f
    y
    p
    cons(x)
    
    pause
end
% ===============================================================

% Return true if converged, false otherwise
info = Converged;
