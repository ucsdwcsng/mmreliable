%%--Simulation to verify super resolution algorithm
clearvars
close all

%for raghav: this is a single implementation of superresolution code
% 

% steps:
% 1. create wireless channel using two paths and their sinc interpolation
% 2. Apply super resolution algo and separate two peaks --> estimate power
% Note: This simulation assumes that the ToF has been estimated already. We
% only estimate the power of each individual sincs using the known ToF
% values and mathematically defining the sinc around that ToF with sinc
% width depending on the bandwidth of the wireless system.

% N_SC = 256; % number of subcarriers
BW = 400e6; % bandwidth
fs = 10*BW; % sampling rate
c=3e8; % speed of light
dist = [4, 5]; % distance of directed and reflected path (m)
tau = dist/c;
relativeTau = (tau(2:end)-tau(1))*1e9; % in ns
h_complex = [.75, 1];

%represent continuous channel at say 100*BW
h_ideal = zeros(1,1025);
delayTap = round(tau*100*BW);

h_ideal(delayTap) = h_complex;



% figure;
% plot(abs(h_ideal))
%%--get sincs at tau TOF
t=(-100:1:200)/fs;
[T,Tau] = ndgrid(t,tau);
h_sinc_mat = sinc(BW*(T-Tau));

%%--generate dummy channelfrom sincs 
h_sinc_mat_wt = h_sinc_mat*diag(h_complex);
h_sinc = sum(h_sinc_mat_wt,2);

%%--estimate the channel parameter
h_est = lsqminnorm( h_sinc_mat,h_sinc );


figure(1);
plot(t*1e9,db(h_sinc_mat_wt), 'linewidth',2)
hold on
plot(t*1e9,db(h_sinc), 'linewidth',2)
grid on
grid minor
ylim([-30,0])
xlabel('time (ns)'); ylabel('CIR (dBm)')
set(gca,'fontsize',13)
legend('path 1', 'path 2', 'mixed CIR')

