%%Problem 5
%% Question 5.4
clear all
A = [-1 1 1 -1 0;2 2 -2 0 -1]';
H = [2 0;0 2];
b = [2 6 2 0 0]';
g = [-2 -5]';
x0 = [0.5,0]';
[Xmine,iterations] = InteriorPointSolver(H, g, A, b, x0);
Xmine
% X = quadprog(H,g,-C,-d,A',b,[],[],x0);
% comparison = [Xmine X]

%% Question 5.5

returns = 2.0:0.05:17.60;
varInterior = [];
varQuad = [];
for ret = returns
    b = [ret; 1];
    [xi,iterations] = InteriorPointSolver(H, g, A, b, C, d, x0);
    X = quadprog(H,g,-C,-d,A',b,[],[],x0);
    var = xi'*H*xi;
    varInterior = [varInterior, var];
    varQ = X'*H*X;
    varQuad = [varQuad, varQ];
end

figure
p = plot(returns,varInterior,'g',returns,varQuad,'b')
legend('CustomAlgorithm','QuadProg')
p(1).LineWidth = 2;

