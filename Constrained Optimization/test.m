A = [-1 ;2]';
H = [2 0;0 2];
b = [2]';
g = [-2 -5]';

[EQTx, EQTlambda] = EqualityQPSolver(H, g, A, b);
EQTx
EQTlambda


A = []';
H = [2 0;0 2];
b = [];
g = [-2 -5]';

[EQTx, EQTlambda] = EqualityQPSolver(H, g, A, b);
EQTx
EQTlambda

