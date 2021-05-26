%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sim_super_resolution.m
% Author: Ish Jain
% Date Created: Dec 1 2020
% Description: This script creates a multi-beam channel comprising of
% individual channels from each component beam. It then uses the
% superresolution algorithm to predict the per-beam amplitude of each
% component beam.
% This simulation assumes that per-beam Time of Flights (ToFs) have already 
% been estimated in the beam-training phase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars
close all

%% Parameters
BW = 400e6; % Analog bandwidth (Hz)
fs = 10*BW; % Sample rate (Hz)
c  = 3e8;   % speed of light (m/s)
dist = [4, 5]; % per-beam channel Distance of Flight (m)
tau = dist/c; % Per-beam channel Time of Flight (ToF), measured during beam training
h_complex = [.75, 1]; % Cmplx attenuation of each constituent beam's channel

%% Algorithm
% Note: This simulation assumes that the ToF has been estimated already. We
% only estimate the power of each individual sincs using the known ToF
% values and mathematically defining the sinc around that ToF with sinc
% width depending on the bandwidth of the wireless system.s

% STEP 1: create wireless channel using two paths and their sinc interpolation
t=(-100:1:200)/fs;
[T,Tau] = ndgrid(t,tau); 
h_sinc_mat = sinc(BW*(T-Tau)); % get sincs at tau TOF
% generate superposed channel from sincs
h_sinc_mat_wt = h_sinc_mat*diag(h_complex);
h_sinc = sum(h_sinc_mat_wt,2);
%--

% STEP 2: Apply super resolution and separate two peaks --> estimate power
% per beam.
h_est = lsqminnorm(h_sinc_mat, h_sinc);
%--

fprintf("---------------------\n")
fprintf("Estimated Per-Beam Amplitudes: \n")
disp(h_est.')
fprintf("Actual Per-Beam Amplitudes: \n")
disp(h_complex)

%% Plotting
figure(1);
plot(t*1e9,db(h_sinc_mat_wt), 'linewidth',2)
hold on
plot(t*1e9,db(h_sinc), 'linewidth',2)
hold off
grid on
grid minor
ylim([-30,0])
xlabel('time (ns)'); ylabel('Channel Impulse Response (CIR, dB)')
set(gca,'fontsize',13)
legend('path 1', 'path 2', 'mixed CIR')

