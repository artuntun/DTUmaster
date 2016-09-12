%
% Test SQP Algorithm
% 
clear

% Define function handles to objective and constraints
ObjFun = @ObjFun1;
ConFun = @ConFun1;

% Initial Guess of the Solution
x0=[-1.8, 1.7, 1.9, -0.8, -0.8]';


% Call SQP Algorithm
[x,info,iter,y,f] = SQPeqBFGS(x0)




