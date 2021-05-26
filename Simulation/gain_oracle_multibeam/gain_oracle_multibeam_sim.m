%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gain_oracle_multibeam_sim.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: In this script, we randomly vary the wireless channel
% characteristics and compute the SNR gain of multi-beam over a single-beam
% solution. We also compare the SNR gain of multi-beam vs the gain provided
% by using a Maximal Ratio Combining based Oracle solution.
% %-------------------
% Outcome: A CDF of SNR gain over single beam across all the runs with
% random channel realizations. When the number of beams used in the
% multi-beam is close to number of paths in the channel, it performs very
% similar to the oracle solution. The multi-beam always performs better, or
% at the same level as a single beam.
% %-------------------
% This simulation assumes that the Angles of Departure (AoD) of the
% constituent beams are known exactly in advance through beam training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
close all
plot_flag = 0;

%% Parameters
h.nPaths = 3; % Number of channel paths
Numiter = 100; % Number of iterations
Numbeams = 2; % Number of beams in multi-beam
assert(Numbeams<=h.nPaths,"Numbeams should be <= h.nPaths")
NumAnt = 8; % Number of antennas in the array
Pt = 20; % normalized transmit power in dB
rng(1);
clear SNRgain_multi SNRgain_oracle
count=0; %counting exceptional cases when SNR is too high


%% MonteCarlo
for iter = 1:Numiter
    %--STEP 1: Randomly generate channel parameters
    h.AOD = round(unifrnd(-60, 60, h.nPaths,1)); %degree
    h.mag = [0; sort(unifrnd(-30,-3, h.nPaths-1,1), 'descend')]; %dB
    h.phase = [0; unifrnd(0,360, h.nPaths-1,1)]; %deg
    h.magabs = db2mag(h.mag);
    h.complex = h.magabs.*exp(1j*deg2rad(h.phase));
    %---------------------------
    
    %--STEP 2: Compute Multi-Beam and Single Beam weights.
    beamAOD = h.AOD(1:Numbeams).'; 
    beamAmplitude = h.magabs(1:Numbeams).';
    beamPhase = -h.phase(1:Numbeams).'; 
    [wsingle,bm] = get_multibeam_weights(beamAOD(1),1,0,NumAnt,0);
    Bsingle=bm.B;
    [wmulti, bm2] = get_multibeam_weights(beamAOD,beamAmplitude,beamPhase,NumAnt,0);
    Bmulti=bm2.B; theta=bm2.theta;
    %---------------------------
    
    %--STEP 3: Compute Oracle weights based on Maximal Ratio Combining
    for n=1:NumAnt % assume 8 antennas
        h_all_antenna(n,1) = sum(h.complex.*exp(1j*pi*(n-1)*sind(h.AOD)));
    end
    w_oracle_unnorm = conj(h_all_antenna);
    woracle = w_oracle_unnorm/norm(w_oracle_unnorm);
    Boracle = get_beam_pattern_from_weights(woracle);
    %---------------------------
    
    %--STEP 4: Compute Absolute SNR and SNR gain over single-beam
    SNR_multi(iter) = get_SNR_from_beam_and_channel(h, Bmulti, theta, Pt);
    SNR_single(iter) = get_SNR_from_beam_and_channel(h, Bsingle, theta, Pt);
    SNR_oracle(iter) = get_SNR_from_beam_and_channel(h, Boracle, theta, Pt);
    
    SNRgain_multi(iter) = SNR_multi(iter)-SNR_single(iter);
    SNRgain_oracle(iter) = SNR_oracle(iter)-SNR_single(iter);
    %---------------------------
    
end


%% Plotting
fig1han = figure(125);clf;

g=cdfplot(SNRgain_oracle);
hold on; grid on;
cdfplot(SNRgain_multi);

xline(0, 'linewidth', 2);
xlim([-2,6])
l=legend('Oracle','Multi-beam', 'Single Beam');
xlabel('SNR gain (dB)')
ylabel('CDF')
title(sprintf('Simulation: Num iter=%d, numpaths=%d', Numiter, h.nPaths))
set(l,'fontsize', 12)

fig2han = figure(126); clf;
snr = [SNR_oracle.', SNR_multi.', SNR_single.'];
rss_mean = mean(snr,1);
rss_std = std(snr,1);

bar(rss_mean, 'base', 24, 'Facecolor', [0.9290, 0.6940, 0.1250], 'barwidth', 0.6);
grid on; hold on;
errorbar(1:3, rss_mean, rss_std, 'k.')
xlim([0.5,3.5])
xticklabels({'Oracle', 'Multi-Beam', 'Single Beam'})
ylabel('SNR (dB)')
xlabel('Beamforming Type')
title(sprintf('Simulation: Num iter=%d, numpaths=%d', Numiter, h.nPaths))
set(gca, 'fontsize',12);
% set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 4]) % Use 6,4 or 6,3 or 6,5 judiciously depending on space in the paper (2fig/column or 1fig/column)

if(plot_flag)
    saveas(fig1han, sprintf('figures/cdf_multibeam_oracle_singlebeam_snrimprove_=%d.png', h.nPaths))
    saveas(fig2han, sprintf('figures/multibeam_oracle_singlebeam_snrimprove_=%d.png', h.nPaths))
end