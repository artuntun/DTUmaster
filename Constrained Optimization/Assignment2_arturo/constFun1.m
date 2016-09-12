function [c,dc,d2c] = constFun1(x)

x1 = x(1,1);
x2 = x(2,1);

tmp = x1 + 2;

%constraint function 
c = tmp^2 -x2;

%gradient constraint
dc = zeros(2,1);
dc(1,1) = 2*tmp;
dc(2,1) = -1;

%Hessian of constraint
d2c = zeros(2);
d2c(1,1) = 2;