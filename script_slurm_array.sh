#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

dirpdfs=(NNPDF31_nlo_as_0118)
inputfile=(powheg.input)

mkdir -p ${MYDIR}/risultati/
echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=24-0:0
#SBATCH --array=1-100

#SECONDS=0

ID=\$SLURM_ARRAY_TASK_ID
DIR_RESULTS=${MYDIR}risultati/ris_\$ID/
FILEOUT=out-\$ID.tar.gz
mkdir -p \$DIR_RESULTS
cd \$SLURM_TMPDIR

#echo task id: \$ID
cp ${MYDIR}pwhg_main .
cp ${MYDIR}$inputfile .
cp ${MYDIR}pwgseeds.dat .
export LHAPATH=${HOME}/local/share/LHAPDF/

echo \$ID | ./pwhg_main > powheg-\$ID.output

#duration=\$SECONDS
#echo \$duration
#echo minutes: ((\$duration / 60))

#copy from slurm directory
tar cvzf \$FILEOUT ./* 

cp \$FILEOUT \$DIR_RESULTS" > a.sh

cat a.sh
sbatch --partition=general a.sh

sleep 0.5s

mkdir -p file_log/
