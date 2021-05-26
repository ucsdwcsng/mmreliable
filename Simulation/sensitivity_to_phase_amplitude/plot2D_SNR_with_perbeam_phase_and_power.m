%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot2D_SNR_with_perbeam_phase_and_power.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: This script tests the sensitivity of the gains due to
% multi-beam when the per-beam amplitude and phases are inaccurately
% estimated. While multi-beam provides higher SNR by exploiting
% environmental reflections, it could degrade due to inherent noisiness in
% the estimation of important parameters.
% %-------------------
% Outcome: The sensitivity of SNR gain as the per-beam amplitude/phase is
% estimated incorrectly in a two-beam multi-beam setup. We see from the
% generated plot that even if per-beam phase and amplitude are not known
% accurately, multi-beam still provides SNR gain and is tolerant to these
% errors.
% %-------------------
% This simulation assumes that the Angles of Departure (AoD) of the
% constituent beams are known exactly in advance through beam training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
close all
plot_flag = 0;

%% Parameters

% Ground truth channel parameters
h.AOD = [0, 30];  % degrees
h.mag = [0, -3];  % db values
h.phase = [0, 40];% degree
h.nPaths = length(h.mag); % number of sparse channel paths

h.magabs = db2mag(h.mag);
h.complex = h.magabs.*exp(1j*deg2rad(h.phase));
%---------------------------

% Parameter sweep for generating plot
beam.AmpdBlist = 0:-1:-20;
beam.Phaselist = -180:5:180;
SNR_multi = zeros(length(beam.AmpdBlist), length(beam.Phaselist));
SNR_single = zeros(length(beam.AmpdBlist), length(beam.Phaselist));
SNR_oracle = zeros(length(beam.AmpdBlist), length(beam.Phaselist));
%

%% Simulation
% Steps
% 1. Fix a 2-path channel
% 2. Assume 2-beams in a multi-beam
% 3. Vary the relative phase and relative amplitude of 2nd beam w.r.t.
% first beam and plot SNR for each of those values

% Loop on phase and amplitude of 2nd beam
for pid = 1:length(beam.Phaselist)
    for aid = 1:length(beam.AmpdBlist)
        beamAOD = h.AOD;
        beamAmplitude = [1,db2mag(beam.AmpdBlist(aid))];
        beamPhase = [0,beam.Phaselist(pid)];

        [wsingle,bs] = get_multibeam_weights(beamAOD(1),1,0,8,0);
        Bsingle = bs.B;
        [wmulti,bm ] = get_multibeam_weights(beamAOD,beamAmplitude,beamPhase,8,0);
        Bmulti=bm.B;
        theta=bm.theta;
        
        SNR_multi(aid,pid) = get_SNR_from_beam_and_channel(h, Bmulti, theta);
        SNR_single = get_SNR_from_beam_and_channel(h, Bsingle, theta);
        
    end
end

%% Plotting
ff=figure(113); clf
ccolor = jet(256);
newmap = [repmat(ccolor(1,:), 256,1); ccolor(1:200,:)];
colormap(newmap);

imagesc( beam.Phaselist,beam.AmpdBlist, SNR_multi-SNR_single); axis 'xy';
cc = colorbar;
set(cc,'Ylim',[-4 2]);
ylabel(cc,'SNR gain', 'fontsize', 15)
xlim([-180,180])
ylabel('Amplitude (dB)')
xlabel('Phase (deg)')
hold on;
linhan1 = xline(-h.phase(2),'LineWidth',2);
yline(h.mag(2),'LineWidth',2);
xticks(-160:40:160)
set(gca,'fontsize',14 )
set(ff,'Units','Inches');
pos = get(ff,'Position');
set(ff,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)+5]);
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 2]); % Use 6,4 or 6,3 or 6,5 judiciously depending on space in the paper (2fig/column or 1fig/column)

title(["SNR Gain with errors.", "Lines represent ideal phase and magnitude"])

if(plot_flag)
    saveas(gcf,fullfile('figures','plot2D_multibeam_SNR_with_perbeam_phase_and_power.png'))
end
