clc
clear all
%%----Problem3
A = [-1 1 1 -1 0;2 2 -2 0 -1]';
H = [2 0;0 2];
b = [2 6 2 0 0]';
g = [-2 -5]';
x0 = [0.5,0]';

[x, lambda] = IQPSolver(H, g, A, b,x0);
