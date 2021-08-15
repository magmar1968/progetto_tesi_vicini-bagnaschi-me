#!/bin/bash

HEAD="<initrwgt>\n"
TAIL="</inittwgt>\n"


make_body () {
	_body="<weightgroup name='$1'>\n"
	for((i=$2; i<=$3 ; ++i))
	do
		PDF=$i
		ID=$(($i - $2)) 
		_body="${_body}<weight id='$ID' > lhapdf=$PDF </weight>\n"
	done
	_body="${_body}</weightgroup>\n"
	echo -e $_body 
}

BODY=$HEAD
make_body NNPDF312 303400 303500 > APPO
BODY="${BODY}$APPO"
make_body CT18NLO 14400 14458 > APPO
BODY="${BODY}$APPO"
make_body MSHT20nlo_as118 27100 27165 > APPO
BODY="${BODY}$APPO"
BODY="$BODY$TAIL"

echo -e $BODY
		
