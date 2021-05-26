%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% superresolution_analysis.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: This script builds on sim_super_resolution.m and performs a
% Monte Carlo simulation to understand the true resolution of the
% superresolution algorithm. The Monte Carlo simulation is performed by
% adding noise to the channel estimates to simulate practical noisy
% estimates. While the two paths can be resolved without any error when
% estimation is noise-free, it is not the case when there is noise.  
% %-------------------
% Outcome: the mean square error in per-beam amplitude estimation as a
% function of the relative Time of Flight (ToF) offset between the
% individual beams. The closer they are in ToF, the tougher it is to
% resolve them. We compare the performance of superresolution w.r.t normal
% amplitude measurement and show that superresolution can resolve smaller
% ToF differences.
% %-------------------
% This simulation assumes that per-beam Time of Flights (ToFs) have already 
% been estimated in the beam-training phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
close all
plot_flag = 0; % Turn on to save figures as png images

%% Parameters
N_SC = 256; %number of subcarriers
BW = 400e6; % bandwidth
fs = 10*BW; % sampling rate
c=3e8; % speed of light
dist = 4; % distance of directed path Tx to Rx(m)
tau0 = dist/c;
SNR = 10; %db
debug_flag=0;
tauListRel = (0:.5:15)*1e-9; % relative tau in s

h_complex = [.75*exp(1j*pi/4); 1*exp(1j*pi/2)]; %complex channel taps
numiter = 1000;

%% Monte Carlo
for iter = 1:numiter
    %for each iter, add random noise for a given SNR and calculate MSEavg
    h_complex = randn(2,1)+1j*randn(2,1);
    
    for tind = 1:length(tauListRel)
        tau = [tau0, tau0+tauListRel(tind)]; % delay taps for two paths
        
        % Create Channel
        t=(-50:1:205)/fs;
        [T,Tau] = ndgrid(t,tau);
        h_sinc_mat = sinc(BW*(T-Tau));
        h_sinc_mat_wt = h_sinc_mat*diag(h_complex);
        h_sinc = sum(h_sinc_mat_wt,2);
        
        % Add noise
        H_sinc = fft(h_sinc,N_SC) ;
        H_sinc_noise = awgn(H_sinc, SNR, 'measured');
        h_sinc_noise = ifft(H_sinc_noise,N_SC);
        
        %%--superresolution based amplitude estimate
        h_est = lsqminnorm(h_sinc_mat, h_sinc_noise);
        
        %%--normal amplitude estimate direct from channel PSD
        h_est_pow= h_sinc_noise(round(tau*fs)+51); %plot starts from -50 sample of t
        
        %%--Compute error from true per-beam channel amplitudes
        MSE_superres(:,iter,tind) = abs(h_complex)-abs(h_est); 
        MSE_normal(:,iter,tind) = abs(h_complex)-abs(h_est_pow);
        
    end
end
MSEavg_superres = squeeze(sqrt(mean(MSE_superres,2).^2));
MSEavg_normal = squeeze(sqrt(mean(MSE_normal,2).^2));


%% Plotting
figure(2);clf;
semilogy(tauListRel*1e9,MSEavg_normal(1,:).','linewidth',2)
grid on;hold on;
semilogy(tauListRel*1e9,MSEavg_superres(1,:).','linewidth',2)

xlabel('Relative ToF (ns)'); ylabel('MSE of power estimate')
ll=legend('w/o super-resolution','w/ super-resolution');

set(ll,'fontsize',18);

set(gca,'fontsize',18)
set(ll,'location','best');
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 4])

if(plot_flag)
    saveas(gcf,fullfile('figures','superresolution_analysis.png'))
end
