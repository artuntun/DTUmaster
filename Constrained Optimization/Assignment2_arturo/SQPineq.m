function [x,info,iter,y,f] = SQPineq(x)
% SQPeq1   Solves an equality constrained NLP by the SQP algorithm
%
%   Solves the eqaulity constrained NLP
%
%       min f(x)    s.t. c1(x) >= 0
%                        c2(x) >= 0
%
% Syntax; [x,info,iter,y,f] = SQPeq1(obj,con,x0)
%
%       obj: [f,df,d2f] = obj(x)
%       con: [c,dc,d2c] = con(x)


tol = 1.0e-6;   % Tolerance
maxit = 100;    % Maximum number of iterations

%Evaluate Objective and Constraints
[f,df,d2f] = ObjFun(x);
[c,dc,d2c] = constFun1(x);
[c2,dc2,d2c2] = constFun2(x);

% Number of Lagrange Multipliers
y = zeros(2,1);
B = eye(2);

% Gradient of Lagrangian
dL = df - [dc'; dc2']*y;

Converged = (norm(dL,inf) < tol); 
OPTIONS = optimoptions('quadprog',...
    'Algorithm','interior-point-convex');
iter = 0;
xnew = x;
while ~Converged && (iter<maxit)
    iter = iter + 1;
    
    % Compute Hessian matrix: H = d2L = d2f - \sum( y(i)*d2c(:,:,i) )
    H = d2f - y(1,1)*d2c - y(2,1)*d2c2;
    f = df;  A = [dc dc2]; b = [c;c2];
    %A = [dc dc2], b = [c;c2]; and quadprog(H,f,-A',b.. converge to 
    % -3.6546, 2.7377 after going to high values
    %A = [dc dc2], b = [c;c2]; and quadprog(H,f,A',b..
    %      converge to 3.5859, -1.84 (not feasible) in few iterations
    %      This one should be the correct as in theory.
    %A = [dc' ;dc2'], b = [c;c2]; and quadprog(H,f,A',b..
    %      converge to 3.5859, -1.84 (not feasible) in some iterations
    %A = [dc' ;dc2'], b = [c;c2]; and quadprog(H,f,-A',b..
    %      not converging
    
    [dx,fval,exitflag,output,y] = ...
        quadprog(H,f,A',b,[],[],[],[],xnew,OPTIONS);
    
    y = y.ineqlin;
    dLold = df -A*y;
    xold = xnew
    xnew = xold + dx
    % Evaluate objective and constraints
    [f,df,d2f] = ObjFun(xnew);
    [c,dc,d2c] = constFun1(xnew);
    [c2,dc2,d2c2] = constFun2(xnew);
    % Gradient of Lagrangian
    dL = df - A*y;
    
    %Updated Hessian
    p = dx;
    q = dL-dLold;
    
    if(p'*q<0.2*p'*(B*p))
        theta = (0.8*p'*(B*p))/((p'*(B*p))-(p'*q));
    else
        theta = 1;
    end
    
    r =  theta*q+(1-theta)*(B*p);
    B = B + ((r*r')/(p'*r)) - (((B*p)*(B*p)')/(p'*(B*p)));
    Converged = (norm(dL,inf) < tol);
    pause;
end
