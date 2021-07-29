#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

dirpdfs=(NNPDF31_nlo_as_0118)
inputfile=(powheg.input)

echo "#!/bin/bash
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=1G
#SBATCH --time=20-0:0
#SBATCH --array=1-3

ID=\$SLURM_ARRAY_TASK_ID
RISULTATI=${MYDIR}/risultati/ris_\$ID/
mkdir -p \$RISULTATI
cd \$SLURM_TMPDIR

echo task id: \$ID
cp ${MYDIR}pwhg_main .
cp ${MYDIR}$inputfile .
cp ${MYDIR}pwgseeds.dat .
export LHAPATH=${HOME}/local/share/LHAPDF/

echo \$ID | ./pwhg_main > powheg-\$ID.output
cp powheg-\$ID.output \$RISULTATI
cp ./* \$RISULTATI" > a.sh

cat a.sh
sbatch --partition=general a.sh

sleep 0.5s
