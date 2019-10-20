for ((i=1;i<=109;i++))
do
   for tt in time1 time2
   do
	echo ${tt}_$i
        if [ -d "./${tt}/$i" ]; then
        fmriname=$PWD/${tt}/$i/RS/rs.feat/filtered_func_data2std_NN_retrend.nii.gz
        /home/tllab/jlv/exe/Extract_Whole_brain_signal $fmriname MNI152_2mm_mask.nii.gz 1 ./Whole_b_signals/${i}_${tt}
  
fi   
done
done
