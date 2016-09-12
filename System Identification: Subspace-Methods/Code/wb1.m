function [dataInOut] = wb1(dets,A,B,C,s2)
global data % some data and time administration
data=[];
global As Bs Cs Ds en

% dets=0; % deterministisk (1) eller stokastisk (0) simulation
%------------------------------------------------------------------------
[A,B,k,C,s2]=sysinit1(dets,A,B,C,s2); % Determine linear model (ie. get system)
%------------------------------------------------------------------------
% Reference signal
refsig=1; % 1-5
switch refsig,
 case 1, wt=zeros(1000,1);			% zero
 case 2, wt=[zeros(30,1); ones(70,1)];		% Step function
 case 3, wt=prbs(1000,15);			% PRBS
 case 4, wt=sqwave(100,25);			% square wave
 case 5, wt=0.1.*randn(1000,1);			% white noise
end
nstp=length(wt);
%------------------------------------------------------------------------
% The fixed parameter controller
% ireg=-1 Uncontrolled (u_t=0).
% ireg=0  ut=wt (exitattion)
% ireg=1  MV0
% ireg=2  PZ
% ireg=3  MV1a
% ireg=4  MV1
% ireg=5  GSP (Poleplacement controller)
% Ireg=6  LQG
% ireg=7  MV2 
ireg=0;

if ireg==-1,
 Q=0; S=0; R=1;

elseif ireg==0,
 Q=1; S=0; R=1;

%------------------------------------------------------------------------
measinit;		% Initilialise the measurement system
for it=1:nstp,
 w=wt(it);
 [y,t]=meas;
 %  u=Cr*Xr+Dr*[wf;-y];             % Fixed parameter controller
 u=w;
 
 data=[data; t w y u s2*en];
 act(u);	 		 % Actuate control 
end

%%%Just returning the input and the output
y = data(:,3); 
u = data(:,4);
e = data(:,5);
dataInOut=[y u e];


%------------------------------------------------------------------------
% plt 				  % plot results
%------------------------------------------------------------------------
return

end

