%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_multibeam_pattern.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: This script creates a multi-beam pattern with the given
% constituent beam parameters and compares it with a single-beam. The Total
% Radiated Power (TRP) is kept the same by normalizing the beam patterns as
% necesseary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars;
plot_flag = 0; % Turn on to save figures as png images

%% Beam Parameters
% Beam Parameters are set to get multibeam weights that have same TRP as
% single beam weights. The single beam direction is the first element of
% beam.AOD. Arrays can be expanded to create multi-beams with more 
% constituent beams.
beam.AOD   = [0, 30];   % Angle of Departures of Beams (degree)
beam.ampdb = [0, -5];   % Relative amplitude of Beams  (dB) 
beam.phase = [10, 40];  % Relative phases of the Beams (dB)
beam.amp   = db2mag(beam.ampdb);
beam.n_ant = 8;        % Number of antennas in array

% single beam is a degenerate case of multibeam with only 1 component beam
[wsingle,bSingle] = get_multibeam_weights(beam.AOD(1),1,0,beam.n_ant,0);
[wmulti,bMulti] = get_multibeam_weights(beam.AOD,beam.amp,beam.phase,beam.n_ant,0);


%% Plotting
fighan = figure(111);clf;
fighan.Position = [fighan.Position(1:2) 800 600];
plot_beam_pattern(wmulti,bMulti.theta,beam.n_ant)
plot_beam_pattern(wsingle,bSingle.theta,beam.n_ant)

l=legend('Multi-beam', 'Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

subplot(211)
l=legend('Multi-beam','Single-beam');
set(l, 'location', 'northwest')
set(gca, 'fontsize', 12)
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
sgtitle(sprintf('TRP (dB):: Single:%3.2f, Multi:%3.2f', 10*log10(bSingle.TRP), ...
    10*log10(bMulti.TRP)))

if(plot_flag)
    saveas(gcf, sprintf(fullfile('figures','plot_multibeam_pattern.png')))
end