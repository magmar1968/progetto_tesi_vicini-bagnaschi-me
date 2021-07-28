#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/POWHEG-BOX/W_ew-BMNNP/

dirpdfs=(NNPDF31_nlo_as_0118)
inputfile=(powheg.input)

risultati=risultati1
mkdir -p $risultati

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=1-0:0

cd "'$SLURM_TMPDIR'"
cp ${MYDIR}pwhg_main .
cp ${MYDIR}test-el/$inputfile .
cp ${MYDIR}test-el/pwgseeds.dat .
export LHAPATH=${HOME}/local/share/LHAPDF/
./pwhg_main  < $inputfile
ls -la
cp ./* ${MYDIR}${risultati}/" > a.sh

cat a.sh
sbatch --partition=general a.sh

sleep 0.5s
