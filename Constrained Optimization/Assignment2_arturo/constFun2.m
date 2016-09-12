function [c,dc,d2c] = constFun2(x)

x1 = x(1,1);
x2 = x(2,1);


%constraint function 
c = -4*x1*+10*x2;

%gradient constraint
dc = zeros(2,1);
dc(1,1) = -4;
dc(2,1) = 10;

%Hessian of constraint
d2c = zeros(2);