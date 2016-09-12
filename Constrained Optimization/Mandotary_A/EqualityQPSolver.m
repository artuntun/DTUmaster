function [x,lambda]=EqualityQPSolver(H,c,A,b)

[n m] = size(A);
KKT=[H,A; A',zeros(m)];
B=[-c;b] ;
[L,D,p]= ldl(KKT,'lower','vector') ;
zetha = L'\(D\(L\B(p)));
x=zetha(1:n) ;
lambda=zetha(length(x)+1:length(x)+m);
end