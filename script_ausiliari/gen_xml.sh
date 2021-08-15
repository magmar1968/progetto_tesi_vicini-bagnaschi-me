#!/bin/bash
header="<initrwgt>\n"
end="</initrwgt>"

buff="$header"

PDFS=("NNPDF312" "CT8NLO" "MSHT20nlo_as118" )
SINDEX=(303400 14400 27100)
ENINDEX=(303500 14458 27164)
N_PDF=${#PDFS[@]}
ID=0
for((i=0; i < $N_PDF ; ++i)); do
	buff="$buff<weightgroup name='${PDFS[i]}'>\n"
	for((j=${SINDEX[i]}; j <= ${ENINDEX[i]}; ++j)); do
		buff="${buff}<weight id='$ID' > lhapdf=$j </weight>\n"
		ID=$(($ID + 1))
	done
	buff="${buff}</weightgroup>\n"
done
buff="${buff}${end}"
echo -e $buff
echo -e $buff > file.xml

