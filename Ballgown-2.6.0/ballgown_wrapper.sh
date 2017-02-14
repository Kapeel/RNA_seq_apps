#!/bin/bash

#Get StringTie binary
#tar -xvf stringtie-1.3.0.Linux_x86_64.tar.gz
#export PATH=$PATH:./stringtie-1.3.0.Linux_x86_64/

#wrapper script for StringTie
#desgin_matrix="/Users/kchougul/data/testdata/Ballgown/new_runs/Hisat2_Str_ballgown/sensitive_DS_WW/design_matrix"
desgin_matrix=${desgin_matrix}
#ballgownFolder="/Users/kchougul/data/testdata/Ballgown/new_runs/Hisat2_Str_ballgown/sensitive_DS_WW"
ballgownFolder=${ballgownFolder}
#covariate="group"
covariate=${covariate}
runthis=''


if [ -n "${desgin_matrix}" ]; then runthis="$runthis --design ${desgin_matrix}"; fi
if [ -n "${ballgownFolder}" ]; then runthis="$runthis --datadir ${ballgownFolder}"; fi
if [ -n "${covariate}" ]; then runthis="$runthis --covariate ${covariate}"; fi

which R
which Rscript

Rscript ./ballgown.R $runthis

rm -rf ballgown getopt ${ballgownFolder} ${desgin_matrix}
mkdir output
mv results_* Rplots.pdf output
tar -zcvf output.tar.gz output
trap "rm -rf ${ballgownFolder} ${desgin_matrix} output output.tar.gz" exit
