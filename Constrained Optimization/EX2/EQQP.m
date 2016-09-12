function [x,lambda] = EQQP(H,g,A,b)
% EQQP  Solves a strictly convex equality constrained QP
%
%             min  0.5*x'*H*x + g'*x
%              x
%             s.t. A' x = b
%
% Syntax: [x,lambda] = EQQP(H,g,A,b)

[m,n]=size(A);

% Define KKT system
KKT = [H -A';A zeros(m,m)];
rhs = [-g; b];

% LDL Factorize: P'*KKT*P = L*D*L'
[L,D,p] = ldl(KKT,'vector');

% Back substitute
xlambda(p,1) = L'\(D\(L\rhs(p,1)));

% Extract x and lambda
x = xlambda(1:n,1);
lambda = xlambda(n+1:n+m,1);

