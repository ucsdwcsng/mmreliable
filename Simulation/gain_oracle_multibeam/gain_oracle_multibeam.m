

load('expt_all_rss_5m_10iter.mat')%, 'rss_all')

snr = rss_all + 31 + 7.8;

figure(4);clf;

rss_mean = mean(snr,1);
rss_std = std(snr,1);

bar(rss_mean, 'base', 24, 'Facecolor', [0.9290, 0.6940, 0.1250], 'barwidth', 0.6)
% [0.9290, 0.6940, 0.1250]
grid on; hold on;
errorbar(1:4, rss_mean, rss_std, 'k.')
xlim([0.5,4.5])
xticklabels({'Oracle', '3-Beam','2-Beam', '1-Beam'})
ylabel('SNR (dB)')
xlabel('Beamforming Type')

set(gca, 'fontsize',20);
% set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 4]) % Use 6,4 or 6,3 or 6,5 judiciously depending on space in the paper (2fig/column or 1fig/column)

wannasave=0;
if(wannasave)
    saveas(gcf,[pwd,'/figures/gain_oracle_multibeam.pdf'])
    !pdfcrop figures/gain_oracle_multibeam.pdf figures/gain_oracle_multibeam.pdf
end