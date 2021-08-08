#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=24-0:0
#SBATCH --array=1-100

#SECONDS=0

ID=$SLURM_ARRAY_TASK_ID
DIR_RESULTS=/home/lorenzomagnoni/progetto_tesi/risultati/ris_$ID/
FILEOUT=out-$ID.tar.gz
mkdir -p $DIR_RESULTS
cd $SLURM_TMPDIR

#echo task id: $ID
cp /home/lorenzomagnoni/progetto_tesi/pwhg_main .
cp /home/lorenzomagnoni/progetto_tesi/powheg.input .
cp /home/lorenzomagnoni/progetto_tesi/pwgseeds.dat .
export LHAPATH=/home/lorenzomagnoni/local/share/LHAPDF/

echo $ID | ./pwhg_main > powheg-$ID.output

#duration=$SECONDS
#echo $duration
#echo minutes: (($duration / 60))

#copy from slurm directory
tar cvzf $FILEOUT ./* 

cp $FILEOUT $DIR_RESULTS
