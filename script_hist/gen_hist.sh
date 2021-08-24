#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-12:0
#SBATCH --array=1-200

ID=$SLURM_ARRAY_TASK_ID
printf -v PAD_ID %04d $ID

FILE_EVENTS=pwgevents-$PAD_ID.lhe
DIR_RES=/home/lorenzomagnoni/progetto_tesi//histogram/hist-PYTHIA-$ID/
LOG_OUT=log_hist-PYTHIA$PAD_ID.txt
OUT_FILE=out_hist-PYTHIA$PAD_ID.tar.gz

mkdir -p $DIR_RES

cd $SLURM_TMPDIR
tar -xzvf /home/lorenzomagnoni/progetto_tesi/risultati/ris_$ID/out-$PAD_ID-rwgt.tar.gz ./$FILE_EVENTS
cp /home/lorenzomagnoni/progetto_tesi/main-PYTHIA82-lhef .
cp /home/lorenzomagnoni/progetto_tesi/powheg.input .

export LHAPATH=/home/lorenzomagnoni/local/share/LHAPDF/

echo $FILE_EVENTS | ./main-PYTHIA82-lhef > $LOG_OUT

tar cvzf $OUT_FILE ./*.top ./powheg.input ./$LOG_OUT
cp $OUT_FILE $DIR_RES
