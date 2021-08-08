#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=20-0:0
#SBATCH --array=1-100

ID=$SLURM_ARRAY_TASK_ID
RISULTATI=/home/lorenzomagnoni/progetto_tesi/risultati/ris_$ID/
printf -v PAD_ID %04d $ID
EVENTS_FILE=pwgevents-$PAD_ID.lhe
OUT_FILE=out-${PAD_ID}_ph-2.tar.gz
tar -zxvf ${RISULTATI}out-${ID}.tar.gz ./$EVENTS_FILE

cd $SLURM_TMPDIR
cp /home/lorenzomagnoni/progetto_tesi/pwhg_main .
cp /home/lorenzomagnoni/progetto_tesi/powheg.input .
cp /home/lorenzomagnoni/progetto_tesi/nnpdf21_100.xml .
cp $RISULTATI${EVENTS_FILE} .

./pwhg_main $EVENTS_FILE > out_log${PAD_ID}_ph2.txt
tar czvf $OUT_FILE ./*
mv $OUT_FILE $RISULTATI
