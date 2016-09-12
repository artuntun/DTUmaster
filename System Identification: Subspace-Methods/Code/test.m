
%% Analysis of subspace methods for System Identification N4SID
clear all
close all
startup

%% Simulating deterministic system
% wb 
A=[1 -0.98 0.4 -0.4];
B=0;
C=[1 0.3];
s2=0.1;
[data] = wb1(0,A,B,C,s2);

split = 0.8*length(data);
data_train = data(1:split,:);
data_test = data(split+1:end,:);

%% Fit deterministic ARMAX(1,1,0) model
SYSarmax = armax(data_train, [3 0 1 1]);
present(SYSarmax)
[parm p] = th2par(SYSarmax);
estpres(parm, p)
resid(SYSarmax, data_train)

%% Subspace N4SID method
SYSN4SID = n4sid(data_train,'best');
% Ad = SYSsub_det.A; Bd = SYSsub_det.B; Cd = SYSsub_det.C; Dd = SYSsub_det.D;
% [b,a] = ss2tf(Ad,Bd,Cd,Dd)
%% Compare N4SID with data
close all
compare(data_test,SYSN4SID)
hold on
    grid
hold off
%% Compare N4SID system with ARMAX system
close all
step(SYSarmax)
hold on
    step(SYSN4SID)
    legend('ARMAX','N4SID')
    grid
hold off
%% Stochastic-Deterministic N4SID fitting
A=[1 -0.98 0.4 -0.4];
B=2;
C=[1 0.3];
s2=0.1;

noise = [0.01 0.02 0.05 0.1 0.2 0.35 0.5]; %differnet noises
perf_stochdeter = [];
for i= 1:length(noise)
    [perf] = testPerform(A,B,C,noise(i),100,2);
    perf_stochdeter = [perf_stochdeter perf];
end
%% Pure Stochastic N4SID fitting
A=[1 -0.98 0.4 -0.4];
B=0;
C=[1 0.3];
s2=0.1;

noise = [0.01 0.02 0.05 0.1 0.2 0.35 0.5];
perform_stoch = [];
for i= 1:length(noise)
    [perf] = testPerform(A,B,C,noise(i),100,1);
    perform_stoch = [perform_stoch perf];
end
%% 
A=[1 -0.98 0.4 -0.4];
B=0;
C=[1 0.3];
s2=0.01; 

[data] = wb1(0,A,B,C,s2); 
%%
split = 0.8*length(data);
data_train = data(1:split,:);
data_test = data(split+1:end,:);
SYSN4SID = n4sid(data_train,'best');
close all
compare(data_test,SYSN4SID);
hold on
    grid
hold off

%%
u = data_test(:,2:3);
lsim(SYSN4SID,u)
hold on
    lsim(sys,u./s2)
hold off





