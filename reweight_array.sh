#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=20-0:0
#SBATCH --array=1-100

ID=\$SLURM_ARRAY_TASK_ID
RISULTATI=${MYDIR}risultati/ris_\$ID/
printf -v PAD_ID "%04d" \$ID
EVENTS_FILE=pwgevents-\$PAD_ID.lhe
OUT_FILE=out-\${PAD_ID}_ph-2.tar.gz

cd \&SLURM_TMPDIR
tar -zxvf \${RISULTATI}out-\${ID}.tar.gz ./\$EVENTS_FILE
cp ${MYDIR}pwhg_main .
cp ${MYDIR}powheg.input .
cp ${MYDIR}nnpdf21_100.xml .
cp \$RISULTATI\${EVENTS_FILE} .

./pwhg_main \$EVENTS_FILE > out_log\${PAD_ID}_ph2.txt
tar czvf \$OUT_FILE ./*
mv \$OUT_FILE \$RISULTATI" > b.sh

cat b.sh

sbatch --partition=general  b.sh

sleep 0.5s

