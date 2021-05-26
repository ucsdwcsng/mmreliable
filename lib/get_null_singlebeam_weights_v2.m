function [wnew, bm] = get_null_singlebeam_weights_v2(beamAng, whichbeam, wannaplot)
% Ish Jain
% Dec 15 2020

% UPDATE in v2: Instead of null constraint at 2nd beam AOD, I put null 
% constraint with the entire send beam pattern. This will mathematically
% guarantee orthogonal beams :)

%This code be used by get_null2_multibeam_weight.m to get a
% multibeam weight.

% Works for any arbitrary number of beams. Yay!
% Not very accurate if one of the angle is not 0 deg. E.g. [20,50] never
% gives null at 50 deg. Debug it later.

% I used ECE251D lecture-7 by Prof. Bhaskar Rao

if(nargin<3)
    wannaplot=1;
end
if(nargin<2)
    whichbeam=1; %whichbeam in beamAng is main beam, others are null
end
if(nargin<1)
    beamAng = [0,10];
end

% beam directions
beamAOD = beamAng(whichbeam); % main beam direction
nullidx=setdiff(1:length(beamAng),whichbeam);
beamNull = beamAng(nullidx); %null beam direction

N=8; %Number of antennas in ULA
theta = [-90:0.1:90].'; %Range of theta for plotting beampattern

for bid=1:length(beamAng) %create standard single beam patterns
    w(:,bid) = get_multibeam_weights(beamAng(bid),1,0,0);
end

%create nulling
psiall = 2*pi/2*sind(theta); % grid of psi for plotting
for n=1:N
    V(n,:) =  exp(1j*(n-1)*psiall); % array manifold vector
end


%% beam pattern after applying null constraint

%Apply null constraint and get weights
vc = w(:,nullidx);%%V(:,psindx); 
%  vc=vc.';
% Pc = vc*vc'/(vc'*vc); %vector computation
Pc = vc/(vc'*vc)*vc'; %matrix computation: I did this computation on my notebook
Pcp = eye(N)-Pc;
wnew= Pcp*w(:,whichbeam);

% Return beam information
bm.Bsingle = V.'*wnew;
bm.theta=theta;

% Normalize
wnew = wnew./norm(wnew);
if(wannaplot)
    figure(111); clf;
    plot_beam_pattern(wnew, bm.theta,N)
end
end
