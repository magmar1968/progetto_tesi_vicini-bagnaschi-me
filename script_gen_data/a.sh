#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=24-0:0
#SBATCH --array=1-100

ID=$SLURM_ARRAY_TASK_ID
printf -v PAD_ID %04d $ID
RISULTATI=/home/lorenzomagnoni/progetto_tesi//risultati/ris_$ID/
FILEOUT=out-$PAD_ID-rwgt.tar.gz
LOG_OUT=out_log-gen_rwgt-${PAD_ID}.txt

mkdir -p $RISULTATI
cd $SLURM_TMPDIR

echo task id: $ID
cp /home/lorenzomagnoni/progetto_tesi/pwhg_main .
cp /home/lorenzomagnoni/progetto_tesi/powheg.input .
cp /home/lorenzomagnoni/progetto_tesi/pwgseeds.dat .
cp /home/lorenzomagnoni/progetto_tesi/multi_PDF.xml .

export LHAPATH=/home/lorenzomagnoni/local/share/LHAPDF/

echo $ID | ./pwhg_main > $LOG_OUT

#copy from slurm directory
tar cvzf $FILEOUT ./* 

cp $FILEOUT $DIR_RESULTS
