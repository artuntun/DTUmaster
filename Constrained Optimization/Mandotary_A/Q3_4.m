function [x,lambda] = Q3_4(H,c,A,b)
% tmp1 = max(size(A))
% O = zeros(tmp1);
% G = [H A;A' O];
% d = [-c;b];
B1 = -(b + A'*inv(H)*c);
A1 = A'*inv(H)*A;
%eig(A1)
[L,D,p] = ldl(A1,'lower','vector');
lambda = L'\(D\(L\B1(p)));
x = -inv(H)*(c + A*lambda);


% tmp2 = size(x);
% tmp3 = tmp2 -tmp1;
% x = x(1:tmp3);
% lambda = x(tmp3:end);
return;
end

