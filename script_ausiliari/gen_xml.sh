#!/bin/bash
header="<initrwgt>\n<weightgroup name='NNPDF312'>\n"
end="</weightgroup>\n</initrwgt>"
buff="${header}" 

for((i=1; i<=100 ; ++i))
do 
	PDF=$((303400 + $i))
	buff="${buff}<weight id='$i' > lhapdf=$PDF </weight>\n"
done
buff="${buff}${end}"
echo -e $buff
echo -e $buff > file.xml

