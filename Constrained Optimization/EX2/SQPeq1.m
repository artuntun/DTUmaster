function [x,info,iter,y,f] = SQPeq1(x0)
% SQPeq1   Solves an equality constrained NLP by the SQP algorithm
%
%   Solves the eqaulity constrained NLP
%
%       min f(x)    s.t. c(x) = 0
%
% Syntax; [x,info,iter,y,f] = SQPeq1(x0)
%
%       obj: [f,df,d2f] = obj(x)
%       con: [c,dc,d2c] = con(x)

tol = 1.0e-6;   % Tolerance
maxit = 100;    % Maximum number of iterations

% Initialize
iter = 0;
x = x0;

% % Evaluate function and constraint
% [f,df,d2f]=feval(obj,x);
% [c,dc,d2c]=feval(con,x);

[f,df,d2f]=obj(x);
[c,dc,d2c]=cons(x);

% Number of Lagrange Multipliers
m = size(c,1);
y = zeros(m,1);

% Gradient of Lagrangian

dL = df - (dc')*y;  

% Convergence / KKT 1st order conditions
Converged = ( norm(dL,inf) < tol ) && ( norm(c,inf) < tol );

x   % control
f


% ===============================================================
%   Main Loop
% ===============================================================
while ~Converged && (iter < maxit)
    iter = iter + 1;    

    % Compute Hessian matrix: H = d2L = d2f - \sum( y(i)*d2c(:,:,i) )
    H = d2f;
    for i=1:m
       H = H - y(i,1)*d2c(:,:,i); 
    end
    
    % Solve equality constrained QP
    [p,y] = EQQP(H,df,dc,-c);

    % Take step
    x = x+p;
    
%     % Function evaluation 
%     [f,df,d2f]=feval(obj,x);
%     [c,dc,d2c]=feval(con,x);
    
    
    [f,df,d2f]=obj(x);
    [c,dc,d2c]=cons(x);

    % Lagrangian gradient
    dL = df - dc'*y;  

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
