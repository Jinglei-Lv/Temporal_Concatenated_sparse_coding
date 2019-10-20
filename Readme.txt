1. Use the linux exe "Extract_Whole_brain_signal" to extract whole brain signals.
2. Extract_whole_brain_sig.sh is an example script for signal extraction.
3. See the comments for parameters setting in main.m .
4. After running use linux exe "Map_reference2brain“ to map common networks to std brain.
5. Map_Common_networks.sh is an example script for brain mapping.
6. Spams is need for running the code. http://spams-devel.gforge.inria.fr/
7. FSL is needed for visualization.
8. MNI152_2mm_mask.nii.gz is used to extract brain signals and standard.nii.gz is used for overlay.
9. After running common networks will be reconstructed from Common_A_T.txt.
10. Individual dictionary could be found found as XXXXX.D.txt and the connectivity matrix could be found as XXXXX.D.Corr.txt.
11. You could do any statistics or cross group comparison to the connectivities in XXXXX.D.Corr.txt.
