# Artifact mmReliable


## Overview
* Getting started
* Software/Hardware setup
* Run simulations
* Validate results

## Getting started (10 human-minutes)

This repository contains the artifact for submission \#441, ACM SIGCOMM 2021. The artifact is composed of simulations and algorithms implemented on real-life mmWave channel estimates. The folder structure is explained below:   

```
│   README.md
│   startup_script.m    
└───lib 
└───Simulation
│   └───gain_oracle_multibeam
│   └───Multibeam_weight_creation
│   └───probing_overhead
│   └───sensitivity_to_phase_amplitude
│   └───superResolution
```

Each experiment/simulation along with a brief description is detailed below:

1. **Multi-beam weight creation:** This simulation presents our method for generating multi-beam weights an arbitrary number of component beams and phase control (Section 3.2). It also describes how total radiated power (TRP) is preserved and demonstrates orthogonality of component beams (Section 3.3).

2. **Super-resolution:** This simulation describes how superresolution can be applied on the multi-beam channel estimate to recover the per-beam channel (Section 4.3, Figure 7(a) and (b))    

3. **Multi-beam improves SNR compared to single-beam:** This simulation builds on top of No.1 to show how a multi-beam created using our method can take advantage of environmental reflections to improve SNR compared to a single-beam while maintaining the same TRP (Section 6.1.3, Figure 11(d)).

4. **Sensitivity of Multi-beam pattern to gain and phase errors:** Describes the effect of the estimation accuracy of per-beam amplitude and phase on the SNR gain provided by mmReliable (Appendix B, Figure 11(a) and (b)).

5. **Overhead analysis of mmReliable in context of 5G-NR:** Uses common 5G-NR signalling overheads such as SS-Block and CSI-RS to compute the overhead of mmReliable beam management in comparison to beam-training based solutions (Figure 15)      

## Software/Hardware Setup (10 human-minutes + <1 compute-hour)

Recommended Hardware Requirements:
* Intel Core i5 or AMD Ryzen 5 processor or better
* 8 GB RAM

Software Requirements:
* Windows, Linux or MacOS
* **MATLAB 2019a or newer** (no paid libraries required)

## Run Simulations (50 human-minutes, 10 computer-minutes)

### 1: Multi-beam weight creation (5 minutes)
* Run `./Simulation/Multibeam_weight_creation/plot_multibeam_pattern.m` to create multi-beam patterns from a given set of component beams.
- This simulation is a demonstration of how multi-beam patterns can be generated
- Total Radiated Power is kept constant
- Refer to script description and function comments for more details
- Produces a plot in the figures subfolder

### 2: Super-resolution (15 minutes)
* Run `./Simulation/superResolution/sim_super_resolution.m` to create a channel and perform super-resolution to recover the component beam amplitudes.
- This demonstrates how superresolution is implemented and how the algorithm performs sinc-fitting
- Generates a plot in the figures subfolder (Figure 7 (b) in paper)
* Run `./Simulation/superResolution/sim_super_resolution.m` to understand the limits of the superresolution algorithm through Monte Carlo simulations
- Shows that superresolution is far superior to simple peak picking on the channel estimate.
- Generates a plot in the figures subfolder (Figure 7 (a) in paper)

### 3: Multi-beam improves SNR compared to single-beam (15 minutes)
* Run `./Simulation/gain_oracle_multibeam/gain_oracle_multibeam_sim.m` to compare the SNR improvement of multi-beam w.r.t a single beam.
- The simulation also compares mult-beam performance with an oracle MRC beam-pattern
- Figure 11(d)

### 4: Sensitivity of Multi-beam pattern to gain and phase errors (10 minutes)
* Run `./Simulation/sensitivity_to_phase_amplitude/plot2D_SNR_with_perbeam_phase_and_power.m` to understand the sensitivity of multi-beam SNR gain in the presence of parameter estimation errors.
- This generates the plot from Appendix B in the figures subfolder

### 5: Overhead analysis of mmReliable in context of 5G-NR (5 minutes)
* Run `./Simulation/probing_overhead/probing_overhead.m`. It uses parameters from the 5G-NR standard to compute the channel probing overhead
- Generates Figure 15
