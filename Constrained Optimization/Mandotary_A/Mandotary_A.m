%% Q3
clc
clear all
%Q3.1-----------------------------------------
x = -6:0.01:8;
y = -4:0.01:10;
[x1,x2] = meshgrid(x,y);
%q = (x1-1)^2 + (x2-2.5)^2 ;
q = x1.^2 - x1.*2 + x2.^2 - x2.*5 +7.25  ;
figure(1)
[c,h]=contour(x1,x2,q,120,'linewidth',2);
%clabel(c,h)
colorbar
hold on
fill([8 -12 5 -5],[5 -5 3.5 -1.5],[0.7 0.7 0.7],'facealpha',0.2)
fill([-4 16 5 -5],[5 -5 0.5 5.5],[0.7 0.7 0.7],'facealpha',0.2)
fill([12 -8 5 -5],[5 -5 1.5 -3.5],[0.7 0.7 0.7],'facealpha',0.2)
fill([0 0],[5 -5],[0.7 0.7 0.7],'facealpha',0.2)
fill([5 -5],[0 0],[0.7 0.7 0.7],'facealpha',0.2)
%contour(x1,x2,q,20)
figure(2)
surf(x1,x2,q)
%% --------------------------------------------
%% Q3.4-----------------------------------------
A = [-1 1 1 -1 0;2 2 -2 0 -1]
H = [2 0;0 2]
b = [2 6 2 0 0]';
c = [-2 -5]';
[x,lambda]=EqualityQPSolver(H,c,A,b)
%% Q3.5-----------------------------------------
A = [-1 1 1 -1 0;2 2 -2 0 -1]
H = [2 0;0 2]
b = [2 6 2 0 0]';
c = [-2 -5]';
%% ------------------k=0------------------------;
x0 = [2,0]';
g0=grad(H,c,x0);
w0 = {3,5};
H = [2 0;0 2]
c0 = g0;
b0 =zeros(1,2)';
A0 = [1 -2;0 -1]';
[d0,lambda_0]=EqualityQPSolver(H,c0,A0,b0)
%% ------------------k=1------------------------;
x1 = [2,0]';
g1=grad(H,c,x1);
w1 = {5};
H = [2 0;0 2]
c1 = g1;
b1 =0;
A1 = [0 -1]';
[d1,lambda_1]=EqualityQPSolver(H,c1,A1,b1)
%% ------------------k=2------------------------;
x2 = x1 + d1;
g2=grad(H,c,x2);
w2 = {5};
H = [2 0;0 2]
c2 = g2;
b2 =0;
A2 = [0 -1]';
[d2,lambda_2]=EqualityQPSolver(H,c2,A2,b2)
%% ------------------k=3------------------------;
x3 = x2;
g3=grad(H,c,x3);
w3 = {};
H = [2 0;0 2]
c3 = g3;
b3 =0;
A3 = [0 0]';
[d3,lambda_3]=EqualityQPSolver(H,c3,A3,b3)
%% ------------------k=4------------------------;
x4 = [1 1.5]';
g4=grad(H,c,x4);
w4 = {1};
H = [2 0;0 2]
c4 = g4;
b4 =0;
A4 = [0 0]';
[d3,lambda_3]=EqualityQPSolver(H,c3,A3,b3)