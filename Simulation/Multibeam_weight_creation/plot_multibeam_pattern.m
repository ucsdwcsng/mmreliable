%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_multibeam_pattern.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: Code to test phase and power control for a static user
% Compare against oracle and single beam solution
% Consider 2 beam/ 2 path channel for example.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Beam Parameters
% Beam Parameters are set to get multibeam weights that have same TRP as
% single beam weights. The single beam direction is the first element of
% beam.AOD. Arrays can be expanded to create multi-beams with more 
% constituent beams.
beam.AOD   = [0, 30];   % Angle of Departures of Beams (degree)
beam.ampdb = [0, -5];   % Relative amplitude of Beams  (dB) 
beam.phase = [10, 40];  % Relative phases of the Beams (dB)
beam.amp   = db2mag(beam.ampdb);

plot_flag  = 0;  % flag for plotting+saving figure.

[wsingle,bSingle] = get_multibeam_weights(beam.AOD(1),1,0,0);
[wmulti,bMulti] = get_multibeam_weights(beam.AOD,beam.amp,beam.phase,0);


%% Plotting
fighan = figure(111);clf;
fighan.Position = [fighan.Position(1:2) 800 600];
plot_beam_pattern(wmulti)
plot_beam_pattern(wsingle)


l=legend('Multi-beam', 'Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)

subplot(211)
l=legend('Multi-beam','Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)

% TRP is computed w.r.t power radiated from single element with an
% amplitude of 1
sgtitle(sprintf('TRP (dB):: Single:%3.2f, Multi:%3.2f', 10*log10(bSingle.TRP), ...
    10*log10(bMulti.TRP)))

wannasave=0;
if(wannasave)
    saveas(gcf, sprintf('figures/plot_multibeam_pattern.png'))
end