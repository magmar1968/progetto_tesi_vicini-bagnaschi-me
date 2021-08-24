#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

mkdir -p ${MYDIR}file_log/
mkdir -p ${MYDIR}histogram/

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=0-12:0
#SBATCH --array=1-200

ID=\$SLURM_ARRAY_TASK_ID
printf -v PAD_ID "%04d" \$ID

FILE_EVENTS="pwgevents-\$PAD_ID.lhe"
DIR_RES=${MYDIR}/histogram/hist_\$ID/
LOG_OUT=log_hist-\$PAD_ID.txt
OUT_FILE=out_hist-\$PAD_ID.tar.gz

mkdir -p \$DIR_RES

cd \$SLURM_TMPDIR
tar -xzvf ${MYDIR}risultati/ris_\$ID/out-\$PAD_ID-rwgt.tar.gz ./\$FILE_EVENTS
cp ${MYDIR}lhef_analysis .
cp ${MYDIR}powheg.input .

export LHAPATH=${HOME}/local/share/LHAPDF/

echo \$FILE_EVENTS | ./lhef_analysis > \$LOG_OUT

tar cvzf \$OUT_FILE ./*.top ./powheg.input ./\$LOG_OUT
cp \$OUT_FILE \$DIR_RES" > gen_hist.sh

cat gen_hist.sh
sbatch --partition=general gen_hist.sh

sleep 0.5s




