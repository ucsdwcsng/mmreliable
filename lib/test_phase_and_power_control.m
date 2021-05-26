function [SNR_multi, SNR_single, SNR_oracle, wmulti, wsingle, woracle, bSingle, bMulti]= test_phase_and_power_control( beam, h, wannaplot)

% Ish Jain
% Dec 1 2020
% Code to test phase and power control for a static user
% Compare against oracle and single beam solution
% Consider 2 beam/ 2 path channel for example.


if(nargin<3)
    wannaplot = 1;
end
if(nargin<2)
    
    %%--Initial parameters
    h.AOD = [0, 30, 50]; %deg
    h.powdb = [0, -5, -10]; %db values
    h.phase = [10, 40, 60]; %degree
    
end

%---------------------------
if(nargin<1)
    % Parameters to vary and test
    beam.AOD = [0,30];
    beam.amp = [1,0.56];
    beam.phase = [10,-20];
end
%---------------------------

h.nPaths = length(h.powdb); % number of sparse channel paths
h.magabs = db2mag(h.powdb);
h.complex = h.magabs.*exp(1j*deg2rad(h.phase));

[wsingle,bSingle] = get_multibeam_weights(beam.AOD(1),1,0,0);
[wmulti,bMulti] = get_multibeam_weights(beam.AOD,beam.amp,beam.phase,0);

for n=1:8 % assume 8 antennas
    h_all_antenna(n,1) = sum(h.complex.*exp(1j*pi*(n-1)*sind(h.AOD)) );
    
end
w_oracle_unnorm = conj(h_all_antenna);
woracle = w_oracle_unnorm/norm(w_oracle_unnorm);
Boracle = get_beam_pattern_from_weights(woracle);

SNR_multi = get_SNR_from_beam_and_channel(h, bMulti.B, bMulti.theta);
SNR_single = get_SNR_from_beam_and_channel(h, bSingle.B, bMulti.theta);
SNR_oracle = get_SNR_from_beam_and_channel(h, Boracle, bMulti.theta);

if(wannaplot)
figure(111);clf;
plot_beam_pattern(wmulti)
plot_beam_pattern(woracle)
plot_beam_pattern(wsingle)

legend('Multi-beam',  'Oracle','Single-beam')

end



