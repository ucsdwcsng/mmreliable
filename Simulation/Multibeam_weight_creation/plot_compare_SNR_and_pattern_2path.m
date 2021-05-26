%plot_compare_SNR_and_pattern_2path
%new_name: plot_pattern_trp_mutlibeam

%test_phase_and_power_control.m

% Ish Jain
% Dec 1 2020
% Code to test phase and power control for a static user
% Compare against oracle and single beam solution
% Consider 2 beam/ 2 path channel for example.


%%--Initial parameters
h.AOD = [0, 30];%, 50]; %deg
h.powdb = [0, -5];%, -10]; %db values
h.phase = [10, 40];%, 60]; %degree
%---------------------------

% Parameters to vary and test
beam.AOD = h.AOD;
beam.amp = db2mag(h.powdb);
beam.phase = -h.phase;

[SNR_multi, SNR_single, SNR_oracle, wmulti, wsingle, woracle,bSingle, bMulti]= test_phase_and_power_control( beam, h, 0);
%---------------------------


figure(111);clf;
plot_beam_pattern(wmulti)
plot_beam_pattern(woracle)
plot_beam_pattern(wsingle)


l=legend('Multi-beam',  'Oracle','Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)

subplot(211)
l=legend('Multi-beam',  'Oracle','Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)

sgtitle(sprintf('SNR(dB):: Multi:%3.2f, Oracle:%3.2f, Single:%3.2f', SNR_multi, SNR_oracle, SNR_single))

wannasave=0;
if(wannasave)
    saveas(gcf, sprintf('figures/plot_compare_SNR_and_pattern_2path.png'))
end