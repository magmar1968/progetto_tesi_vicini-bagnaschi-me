#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/

dirpdfs=(NNPDF31_nlo_as_0118)
inputfile=(powheg.input)




echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=20-0:0
#SBATCH --array=1-3

ID="'$SLURM_ARRAY_TASK_ID'"
cd "'$SLURM_TMPDIR'"
cp ${MYDIR}pwhg_main .
cp ${MYDIR}$inputfile .
cp ${MYDIR}pwgseeds.dat .
export LHAPATH=${HOME}/local/share/LHAPDF/
echo $ID | ./pwhg_main  < $inputfile
ls -la
risultati="ris_$ID"
mkdir -p ${risultati}/
cp ./* ${MYDIR}${risultati}/" > a.sh

cat a.sh
sbatch --partition=general a.sh

sleep 0.5s
