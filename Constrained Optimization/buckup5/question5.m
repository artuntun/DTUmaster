%%Question5
clear all
H=[2.3,.93,.62,.74,-.23,0;
    .93,1.4,.22,.56,.26,0;
    .62,.22,1.8,.78,-.27,0;
    .74,.56,.78,3.4,-.56,0;
    -.23,.26,-.27,-.56,2.6,0;
    0,0,0,0,0,0];
g = [0 0 0 0 0 0]';
r=[15.1;12.5;14.7;9.02;17.68;2];
A=[r,ones(6,1)];
b=[15;1];
C=eye(6);
d=zeros(6,1);
x0 = [0.2 0.2 0.2 0.2 0.1 0.1]';

[finalState,iterations,alpha] = InteriorPointSolver(H, g, A, b, C, d, x0);
Xmine = finalState(1:6);
Ymine = finalState(7:8);
Zmine = finalState(9:14);
Smine = finalState(15:20);
SZe = diag(Zmine) * diag(Smine) * ones(6,1);
X = quadprog(H,g,-C,-d,A',b,[],[],x0);
comparison = [Xmine X]


