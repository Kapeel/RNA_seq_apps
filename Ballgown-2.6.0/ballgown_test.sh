#!/bin/bash

#Get StringTie binary
#tar -xvf stringtie-1.3.0.Linux_x86_64.tar.gz
#export PATH=$PATH:./stringtie-1.3.0.Linux_x86_64/

#wrapper script for StringTie
desgin_matrix="/Users/kchougul/data/testdata/Ballgown/new_runs/Hisat2_Str_ballgown/sensitive_DS_WW/design_matrix"
ballgownFolder="/Users/kchougul/data/testdata/Ballgown/new_runs/Hisat2_Str_ballgown/sensitive_DS_WW"
covariate="group"
runthis=''


if [ -n "${desgin_matrix}" ]; then runthis="$runthis --design ${desgin_matrix}"; fi
if [ -n "${ballgownFolder}" ]; then runthis="$runthis --datadir ${ballgownFolder}"; fi
if [ -n "${covariate}" ]; then runthis="$runthis --covariate ${covariate}"; fi

Rscript ./ballgown.R $runthis

mkdir output
mv results_* Rplots.pdf output
tar -zcvf output.tar.gz output

trap "rm -rf output output.tar.gz" exit
 
