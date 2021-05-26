function B = get_beam_pattern_from_weights(weights, theta, N, wannaplot)

if(nargin<4)
    wannaplot=0;
end
if(nargin<3)
    N=8; %Number of antennas in ULA
end
if(nargin<2)
    theta = -90:0.1:90; %Range of theta for plotting beampattern
end

for n=1:N
    psiall = 2*pi/2*sind(theta); % grid of psi for plotting
    V(n,:) =  exp(1j*(n-1)*psiall); % array manifold vector
end

B = V.'*weights; %beampattern

if(wannaplot)
    Bdb = db(B);
    Bdb(Bdb<-30) = -30;
    
    figure(111);
    plot(theta,Bdb)
    grid on;
    % ylim([-20,10])
    xlabel('\theta(deg)'); ylabel('|B| (dB)');
end

end