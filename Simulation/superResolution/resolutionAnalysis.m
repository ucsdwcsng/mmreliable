%%-resolutionAnalysis.m
% Find out how much is the resolution of our super resolutuion

clearvars
% close all

%for raghav: this monte carl of superresolution code

% steps:
% 1. How close two path can be resolved? A. 100% accurate without noise.
% 2. Accuracy in terms of MSE when CSI is corrupted by noise.
% 3. Impact of TOF estimation error.

N_SC = 256; %number of subcarriers
BW = 400e6; % bandwidth
fs = 10*BW; % sampling rate
c=3e8; % speed of light
dist = 4; % distance of directed path Tx to Rx(m)
tau0 = dist/c;
SNR = 10; %db
wannadebug=0;


tauListRel = (0:.5:15)*1e-9; % relative tau in s

% h_complex = [.75; 1];
h_complex = [.75*exp(1j*pi/4); 1*exp(1j*pi/2)]; %complex channel taps


numiter = 1000;
for iter = 1:numiter
    %for each iter, add random noise for a given SNR and calculate MSEavg
    h_complex = randn(2,1)+1j*randn(2,1);
    
    for tind = 1:length(tauListRel)
        tau = [tau0, tau0+tauListRel(tind)]; % delay taps for two paths
        
        t=(-50:1:205)/fs;
        [T,Tau] = ndgrid(t,tau);
        h_sinc_mat = sinc(BW*(T-Tau));
        h_sinc_mat_wt = h_sinc_mat*diag(h_complex);
        h_sinc = sum(h_sinc_mat_wt,2);
        
        %Add noise
        H_sinc = fft(h_sinc,N_SC) ;
        H_sinc_noise = awgn(H_sinc, SNR, 'measured');
        h_sinc_noise = ifft(H_sinc_noise,N_SC);
        
        
        
        %% figure
        if(wannadebug)
            input('have you reduced the number of iterations to one?')
            figure(11);
            subplot(2,2,1)
            plot(abs(fftshift(H_sinc))); title('CSI')
            subplot(2,2,2)
            plot((h_sinc)); title('CIR')
            subplot(2,2,3)
            plot(abs(fftshift(H_sinc_noise))); title('CSI noisy')
            subplot(2,2,4)
            plot((abs(h_sinc_noise))); title('CIR noisy')
        end
        %         h_sinc_noise = awgn(h_sinc, SNR, 'measured');
        %         figure; plot(h_sinc);hold on; plot(h_sinc_noise);
        
        %%--superresolution
        h_est = lsqminnorm( h_sinc_mat,h_sinc_noise );
        
        %%--power estimate
        h_est_pow= h_sinc_noise(round(tau*fs)+51); %plot starts from -50 sample of t
        
        %%--Calculate how good the estimate is by calculating mean square error
        MSE(:,iter,tind) = abs(h_complex)-abs(h_est);
        MSE_pow(:,iter,tind) = abs(h_complex)-abs(h_est_pow);
        
        %         disp(fprintf('MSE=%f and %f', MSE(1), MSE(2)))
        
        %% figure
        if(wannadebug)
            input('have you reduced the number of iterations to one?')
            
            figure(1);clf
            plot(t*1e9,db(h_sinc_mat_wt), 'linewidth',2)
            hold on
            plot(t*1e9,db(h_sinc_noise), 'linewidth',2)
            grid on
            grid minor
            ylim([-30,0])
            xlabel('time (ns)'); ylabel('CIR (dBm)')
            set(gca,'fontsize',13)
            legend('path 1', 'path 2', 'mixed CIR')
            title(['relative tau = ', num2str(tauListRel(tind))])
            pause(1)
        end
    end
end
MSEavg = squeeze(sqrt(mean(MSE,2).^2));
MSEavg_pow = squeeze(sqrt(mean(MSE_pow,2).^2));
% save('figures/MSEfiles.mat','MSEavg','MSEavg_pow');

figure(2);clf;
semilogy(tauListRel*1e9,MSEavg_pow(1,:).','linewidth',2)
grid on;hold on;
semilogy(tauListRel*1e9,MSEavg(1,:).','linewidth',2)


xlabel('Relative ToF (ns)'); ylabel('MSE of power estimate')
ll=legend('w/o super-resolution','w/ super-resolution');

set(ll,'fontsize',18);

set(gca,'fontsize',18)
set(ll,'location','best');
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 4])

SAVE_FIGS=0;
if(SAVE_FIGS)
    input('superres folder?')
    saveas(gcf,[pwd,'/figures/superresMSE.bmp'])
    saveas(gcf,[pwd,'/figures/superresMSE.png'])
    saveas(gcf,[pwd,'/figures/superresMSE.pdf'])
    !pdfcrop figures/superresMSE.pdf figures/superresMSE.pdf
end
