#!/bin/bash

MYDIR=/home/lorenzomagnoni/progetto_tesi/POWHEG/W_ew-BMNNP/

dirpdfs=(NNPDF31_nlo_as_0118)
inputfile=(pwhg.input)

risultati=risultati1
mkdir -p $risultati

echo "#!/bin/bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=2-0:0

cd "'$SLURM_TMPDIR'"
cp ${MYDIR}pwhg_main
cp ${MYDIR}/test-el/$inputfile
export LHAPATH=${HOME}/local/share/LHAPDF/
./pwhg_main < ${inputfile} >out0 
cp out0 ${MYDIR}${risultati}/" >a.sh

sbatch --partition=general a.sh

sleep 0.5s
