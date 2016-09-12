C = [1 ; 0];
A = [1 1];
b = [1];
x = [1 ; 1];
[x, s, lambda, iter] = LinearInteriorPointSolver(C, A, b, x)
[x,info,mu,lambda,iter] = LPippd(C,A,b,x)