#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

dirpdfs=(NNPDF31_nlo_as_0118 CT18NNLO MSHT20nlo_as118)
inputfile=(powheg.input)

mkdir -p file_log
mkdir -p ${MYDIR}/risultati/

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=3-0:0
#SBATCH --array=1-200

ID=\$SLURM_ARRAY_TASK_ID
printf -v PAD_ID "%04d" \$ID
RISULTATI=${MYDIR}/risultati/ris_\$ID/
FILEOUT=out-\$PAD_ID-rwgt.tar.gz
LOG_OUT=out_log-gen_rwgt-\${PAD_ID}.txt
JOBID=\$SLURM_ARRAY_JOB_ID

mkdir -p \$RISULTATI
cd \$SLURM_TMPDIR

echo task id: \$ID
cp ${MYDIR}pwhg_main .
cp ${MYDIR}$inputfile .
cp ${MYDIR}pwgseeds.dat .
cp ${MYDIR}multi_PDF.xml .

export LHAPATH=${HOME}/local/share/LHAPDF/

echo \$ID | ./pwhg_main > \$LOG_OUT

mkdir -p ./file_log/file_log-\$JOBID/

#copy from slurm directory
tar cvzf \$FILEOUT ./*

cp \$FILEOUT \$RISULTATI" > gen_rwgt.sh
#cp \$LOG_OUT ${MYDIR}file_log/file_log-\$JOBID" > gen_rwgt.sh

cat gen_rwgt.sh
sbatch --partition=general gen_rwgt.sh

sleep 0.5s

