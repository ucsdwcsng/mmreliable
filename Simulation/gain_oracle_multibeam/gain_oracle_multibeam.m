%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gain_oracle_multibeam_sim.m
% Author: Ish Jain
% Date Created: Jan 12 2020
% Description: In this script, we plot the SNR (dB) data obtained from our
% experiments. We show that SNR of single beam system is the lowest. 
% Multi-beam system with 3 beam has higher SNR compared to multi-beam with 2-beams 
% only and both are better than single beam. We also show that the SNR of
% 3-beam system is close to the oracle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars
close all
plot_flag = 0; % Turn on to save figures as png images

load('expt_all_rss_5m_10iter.mat')% load RSS data

snr = rss_all + 38.8; % get SNR from received signal strength

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


if(plot_flag)
    saveas(gcf,fullfile('figures','expt_gain_oracle_multibeam.png'))
end