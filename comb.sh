#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=20-0:0
#SBATCH --array=1-226

ID=$SLURM_ARRAY_TASK_ID
printf -v PAD_ID %04d $ID

cd $SLURM_TMPDIR
lenght=${#hist_name[@]}

for((j=0;j < 2;++j))
do
{
	cp /home/lorenzomagnoni/progetto_tesi/combinetop.py .
	if [[ $j -eq 0 ]]
	then
		FILEOUT=./pwgLHEF_analisysis-comb-W${ID}.top
	else
		FILEOUT=./lheoutput_py8_histos-comb-W${ID}.top
	fi
	for((i=1;i < 201;++i))
	do
	{
		printf -v PAD_i %04d $i
		if [[ $j -eq 0 ]]
		then
			file=./pwgLHEF_analysis-${PAD_i}-W${ID}.top
			ziped_file=/home/lorenzomagnoni/progetto_tesi/histogram/hist_${i}/out_hist-$PAD_i.tar.gz
		else
			file=./pwgevents-${PAD_i}.lheoutput_py8_histos-W${ID}.top
			ziped_file=/home/lorenzomagnoni/progetto_tesi/histogram/hist-PYTHIA-${i}/out_hist-PYTHIA$PAD_i.tar.gz
		fi
		tar xzf $ziped_file $file
	}
	done
	if [[ $j -eq 0 ]]
	then
		python combinetop.py -o ${FILEOUT} pwgLHEF_analysis*
	else
		python combinetop.py -o ${FILEOUT} pwgevents*
	fi
	mv $FILEOUT /home/lorenzomagnoni/progetto_tesi/comb_file/
	rm ./*
}
done
