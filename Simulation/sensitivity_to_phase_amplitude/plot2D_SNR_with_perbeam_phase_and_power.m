% Test sensitivity to error in per-beam amplitude and phase.
% Describes the effect of the estimation accuracy of per-beam amplitude 
% and phase on the SNR gain provided by mmReliable.

% Ish Jain
% Dec 1 2020

% Steps
% 1. Fix a 2-path channel
% 2. Assume 2-beams in a multi-beam
% 3. Vary the relative phase and relative amplitude of 2nd beam w.r.t.
% first beam and plot SNR for each of those values
% The figure shows that evben if the per-beam phase and amplitude are not
% known accurately, the SNR gain remains high for a big range of error in
% per-beam phase and amplitude estimation.


clear


%%--Initial parameters
h.AOD = [0, 30];% 50, 60];
h.mag = [0, -3];% -10, -30]; %db values
h.phase = [0, 40];% 60, 378]; %degree
h.nPaths = length(h.mag); % number of sparse channel paths

h.magabs = db2mag(h.mag);
h.complex = h.magabs.*exp(1j*deg2rad(h.phase));
%---------------------------

% Parameters to vary and test

beam.AmpdBlist = 0:-1:-20;
beam.Phaselist = -180:5:180;
SNR_multi = zeros(length(beam.AmpdBlist), length(beam.Phaselist));
SNR_single = zeros(length(beam.AmpdBlist), length(beam.Phaselist));
SNR_oracle = zeros(length(beam.AmpdBlist), length(beam.Phaselist));

% Loop on phase and amplitude of 2nd beam
for pid = 1:length(beam.Phaselist)
    for aid = 1:length(beam.AmpdBlist)
        
        beamAOD = [0,30];
        beamAmplitude = [1,db2mag(beam.AmpdBlist(aid))];
        beamPhase = [0,beam.Phaselist(pid)];
        
        %---------------------------
        
        [wsingle,bs] = get_multibeam_weights(beamAOD(1),1,0,0);
        Bsingle = bs.B;
        [wmulti,bm ] = get_multibeam_weights(beamAOD,beamAmplitude,beamPhase,0);
        Bmulti=bm.B;
        theta=bm.theta;
        h_all_antenna = zeros(8,1);
        for n=1:8 % assume 8 antennas
            h_all_antenna(n,1) = sum(h.complex.*exp(1j*pi*(n-1)*sind(h.AOD)) );
            
        end
        w_oracle_unnorm = conj(h_all_antenna);
        woracle = w_oracle_unnorm/norm(w_oracle_unnorm);
        Boracle = get_beam_pattern_from_weights(woracle);
        
        SNR_multi(aid,pid) = get_SNR_from_beam_and_channel(h, Bmulti, theta);
        SNR_single = get_SNR_from_beam_and_channel(h, Bsingle, theta);
        SNR_oracle = get_SNR_from_beam_and_channel(h, Boracle, theta);
        
    end
end
oraclegap = SNR_oracle-max(max(SNR_multi));

%%
ff=figure(113); clf
% newmap = [zeros(1024, 3); jet(1024)];
ccolor = jet(256);
newmap = [repmat(ccolor(1,:), 256,1); ccolor(1:200,:)];
colormap(newmap)

imagesc( beam.Phaselist,beam.AmpdBlist, SNR_multi-SNR_single); axis 'xy';
% surf( beam.Phaselist,beam.AmpdBlist, SNR_multi-SNR_single, 'EdgeColor', 'interp',...
%     'FaceColor', 'interp'); axis 'xy';
% view(2); grid on;
cc = colorbar;
% set(cc,'Ylim',[-2 max(SNR_multi-SNR_single, [], 'all')])
set(cc,'Ylim',[-4 2])
ylabel(cc,'SNR gain', 'fontsize', 15)
xlim([-180,180])
ylabel('Amplitude (dB)')
xlabel('Phase (deg)')
% title(sprintf('SNR gain of Multi-beam from Single-beam (oracle+%3.2fdB)', oraclegap)); %,  'Oracle','Single-beam')
hold on;
xline(-40)
yline(-3)

xticks(-160:40:160)


% scatter(-40,-3)
set(gca,'fontsize',14 )
% set(findall(gca, 'Type', 'Line'),'LineWidth',2);

set(ff,'Units','Inches');
pos = get(ff,'Position');
set(ff,'PaperPositionMode','Auto','PaperSize',[pos(3), pos(4)+5])

%     title('SNR gain (dB)');
set(gcf,'PaperUnits', 'inches', 'paperposition', [0 0 6 2]) % Use 6,4 or 6,3 or 6,5 judiciously depending on space in the paper (2fig/column or 1fig/column)
    
wannasave=0;
if(wannasave)

    saveas(gcf,[pwd,'/figures/plot2D_multibeam_SNR_with_perbeam_phase_and_power.pdf'])
    !pdfcrop figures/plot2D_multibeam_SNR_with_perbeam_phase_and_power.pdf figures/plot2D_multibeam_SNR_with_perbeam_phase_and_power.pdf
end
