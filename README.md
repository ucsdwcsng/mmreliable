# Artifact mmReliable


## Overview
* Getting started
* Software setup
* Run simulations
* Validate results
* Extending Functions

## Getting started

This repository contains the artifact for submission \#441, ACM SIGCOMM 2021. The artifact is composed of simulations and algorithms implemented on real-life mmWave channel estimates. The folder structure is explained below:   





Each experiment/simulation along with a brief description is detailed below:

1. **Multi-beam weight creation:** This simulation presents our method for generating multi-beam weights an arbitrary number of component beams and phase control (Section 3.2). It also describes how total radiated power (TRP) is preserved and demonstrates orthogonality of component beams (Section 3.3).

2. **Super-resolution:** This simulation describes how superresolution can be applied on the multi-beam channel estimate to recover the per-beam channel (Section 4.3, Figure 7(a) and (b))    

3. **Multi-beam improves SNR compared to single-beam:** This simulation builds on top of No.1 to show how a multi-beam created using our method can take advantage of environmental reflections to improve SNR compared to a single-beam while maintaining the same TRP (Section 6.1.3, Figure 11(d)).

4. **Sensitivity of Multi-beam pattern to gain and phase errors:** Describes the effect of the estimation accuracy of per-beam amplitude and phase on the SNR gain provided by mmReliable (Appendix B, Figure 11(a) and (b)).

5. **Overhead analysis of mmReliable in context of 5G-NR:** Uses common 5G-NR signalling overheads such as SS-Block and CSI-RS to compute the overhead of mmReliable beam management in comparison to beam-training based solutions (Figure 15)      