function SNR = get_SNR_from_beam_and_channel(h, B, theta, Pt)
% Ish Jain
% Dec 1 2020
% called by test_phase_and_power_control

% Input parameters
% h: structure with h.AOD in degree and h.complex as complex channel
% B: Complex beam pattern gain of length same as theta
% theta: Spacial angle (usually -90 to 90 degree with 0.1 increment)
% Pt: Normalized transmit power in dB

if nargin<4
    Pt=0;
end

% get complex antenna gain at the angle of departure ot the gNB
antGain = get_antenna_gain_at_angle(B, theta, h.AOD);

% Get total gain: antenna gain + channel gain (usually <<1 due to high path loss)
allGain = sum(antGain(:).*h.complex(:));

% Add normalized transmit power
SNR = db(allGain) + Pt;

end