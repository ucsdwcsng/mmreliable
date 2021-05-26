function [wmulti, bm] = get_multibeam_weights(beamAng, mbGain, mbPhase, wannaplot)
% Aug 13 2020
% Ish Jain
% Given beamAng angle (Deg), find weights for that beam angle
% If beamAng is vector, return weights for multi-beam link
% beamGain and beamPhase(Deg) contols the gain and phase for multi-beam link
% Returns multi-beam (including single beam) weights with same TRP

% Input:
% beamAng: array of beam pointing angles (deg) for each beam in multibeam
% mbGain: array of magnitude of gain of multibeam (not in dB)
% mbPhase: array of per-beam phases in degree
% wannaplot: plot for debugging

% Output: 
% wmulti: weights for multibeam pattern
% bm: structure containing important info about beam pattern e.g. TRP, EIRP

% Note: you can get single beam weights by calling this function as follows
% [wsingle,bSingle] = get_multibeam_weights(beamAng,1,0,0);


if(nargin<4)
    wannaplot=0;
end
if(nargin<1)
    beamAng=[0,30];
end
if(nargin<3)
    mbPhase = zeros(size(beamAng));
end
if(nargin<2)
    mbGain = ones(size(beamAng)); % Caution not in dB
end

if(length(beamAng)~=length(mbGain))
    error('Wrong Gain vector in multibeam')
end

if(length(beamAng)~=length(mbPhase))
    error('Wrong Phase vector in multibeam')
end
% Assume d=lambda/2 ULA (uniform linear array)

N=8; %Number of antennas in ULA
theta = [-90:0.1:90].'; %Range of theta for plotting beampattern

clear w_unnormalized V
for n=1:N
    psi = 2*pi/2*sind(beamAng); % pointing direction
    psiall = 2*pi/2*sind(theta); % grid of psi for plotting
    w_unnormalized(n,:) = 1/N* exp(-1j*(n-1)*psi); % unnormalized weights
    V(n,:) =  exp(1j*(n-1)*psiall); % array manifold vector
end

%%multibeam with power and phase control
mbweight = mbGain(:).*exp(1j*deg2rad(mbPhase(:)));

wmulti_unnormalized = sum(w_unnormalized*mbweight,2); %unnormalized multibeam
wmulti = wmulti_unnormalized/norm(wmulti_unnormalized); %normalized multibeam

Bmulti = V.'*wmulti; %beampattern

% Calculate EIRP
EIRP = max(db(Bmulti));

% Calculate total radiated power TRP
delta_theta_rad = deg2rad(theta(2)-theta(1));
TRP= db(sum((abs(Bmulti).^2).*cosd(theta.')) * delta_theta_rad);

%%--return parameters
bm.B = Bmulti;
bm.TRP=TRP;
bm.EIRP=EIRP;
bm.theta = theta;
bm.NF = norm(wmulti_unnormalized);

if(wannaplot)
    figure(11); clf;
    plot(theta,db(Bmulti))
    grid on;
    ylim([-20,10])
    xlabel('\theta(deg)'); ylabel('|B| (dB)');
    title(sprintf('TRP = %2.3f dB, EIRP=%2.3f dB',TRP,EIRP));
end
end