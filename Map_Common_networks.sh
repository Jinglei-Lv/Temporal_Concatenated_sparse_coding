
dsize=50
mkdir common_networks

#/home/tllab/jlv/exe/Map_reference2brain ../MNI152_2mm_mask.nii.gz ./output/Common_A_T.txt $dsize ./common_networks/common

for ((i=1;i<=$dsize;i++))
do
   overlay 1 0 ../standard.nii.gz -a ./common_networks/common_map${i}.nii.gz 0.5 2 tmp.nii.gz
   fslroi tmp.nii.gz tmp.nii.gz 0 91 0 109 20 60 
   slicer tmp.nii.gz -S 2 600  ./common_networks/common_${i}.png
   rm tmp.nii.gz 
done

