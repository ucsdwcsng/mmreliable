function plot_beam_pattern(weights, theta, N, isholdon)

if(nargin<4)
    isholdon = 1;
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
Bdb = db(B);
Bdb(Bdb<-40) = -40;

figure(111);
subplot(211)
plot(theta,Bdb)
grid on; if(isholdon), hold on; end
% ylim([-20,10])
xlabel('\theta(deg)'); ylabel('|B| (dB)');

% figure(112);
subplot(212)
plot(theta,(angle(B)))
grid on; if(isholdon), hold on; end
% ylim([-20,10])
xlabel('\theta(deg)'); ylabel('Phase of B (rad)');

end