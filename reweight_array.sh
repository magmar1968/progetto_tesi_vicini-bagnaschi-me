#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=20-0:0
#SBATCH --array=1-100

###VARIABLES DEFINITIONS
ID=\$SLURM_ARRAY_TASK_ID
JOBID=\$SLURM_ARRAY_JOB_ID
RISULTATI=${MYDIR}risultati/ris_\$ID/
printf -v PAD_ID "%04d" \$ID
EVENTS_FILE=pwgevents-\$PAD_ID.lhe
OUT_FILE=out-\${PAD_ID}_ph-2.tar.gz
LOG_OUT=out_log-\${PAD_ID}_ph2.txt


mkdir -p ./file_log/file_log-\$JOBID

###COPYING ALL NECESSARY FILES TO THE WORKING DIRECTORY
cd \$SLURM_TMPDIR
tar -zxf \${RISULTATI}out-\${ID}.tar.gz ./\$EVENTS_FILE
cp ${MYDIR}pwhg_main .
cp ${MYDIR}powheg.input .
cp ${MYDIR}nnpdf31_100.xml .
cp ${MYDIR}pwgseeds.dat .
#cp \$RISULTATI\${EVENTS_FILE} .
mv \$EVENTS_FILE pwgevents.lhe ##pwhg_main look for a file named pwgevents.lhe

echo \$ID | ./pwhg_main > \$LOG_OUT
mv pwgevents-rwgt.lhe pwgevents-rwgt-\${PAD_ID}.lhe
tar czvf \$OUT_FILE ./*
mv \$OUT_FILE \$RISULTATI
mv \$LOG_OUT ${MYDIR}file_log/file_log-\$JOBID" > b.sh

cat b.sh

sbatch --partition=general  b.sh

sleep 0.5s

