function [c,dc,d2c]=ConFun1(x)
% Constraint function   c(x1,x2) = (x1+2)^2 - x2 
%
% Syntax: [c,dc,d2c]=ConFun1(x)

x1 = x(1,1);
x2 = x(2,1);

tmp = x1+2;

% Constraint function
c = tmp^2 - x2;

% Gradient of constraint function
dc = zeros(2,1);
dc(1,1) = 2*tmp;
dc(2,1) = -1.0;

% Hessian of constraint function
d2c = zeros(2,2,1);
d2c(1,1,1) = 2.0;
