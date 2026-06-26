# GaoEtAl2026
Model simulation code for Gao et al "Cerebellar plasticity controls seconds-long adaptive brain-wide internal timing" 2026 


Model Architecture:
   readout/cortex -> fixed random GC input weights
   GC temporal basis: alpha-like temporal filtering with tau spanning 0.1-2 s
   GC -> 2 PCs through trainable weights **using only LTD**
   PC1 and PC2 are encouraged to ramp up and ramp down
   PCs -> readout through fixed symmetric weights

   Model is trained to have readout unit match a target function


 
## Simulate adaption from 2s-delay to 1s-delay

Run cortico_cerebellar_loop_learn_ramp_1to2.m



## Simulate adaption from 1s-delay to 2s-delay

Run cortico_cerebellar_loop_learn_ramp_1to2.m
