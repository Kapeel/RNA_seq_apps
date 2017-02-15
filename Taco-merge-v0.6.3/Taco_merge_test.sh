#!/bin/bash

#Get StringTie binary
#tar -xvf stringtie-1.3.1c.Linux_x86_64.tar.gz
#export PATH=$PATH:./stringtie-1.3.1c.Linux_x86_64/

#wrapper script for StringTie
reference="Sorghum_bicolor.Sorbi1.dna.toplevel.fa"
seqFolder="gtf_output"
annotation="Sorghum_bicolor.Sorbi1.33.chr.gtf"

#output_file="${output_file}"
output_file="taco_merged_out_gtf"
#filter-min-length="${filter-min-length}"
filter-min-length=200
#filter-min-expr="${filter-min-expr}"
filter-min-expr=0
#isoform-frac="{isoform-frac}"
isoform-frac=0.05
#max-isoforms="${max-isoforms}"
max-isoforms=0
runthis=''

if [ -n "${output_file}" ]; then runthis="$runthis -o ${output_file}"; fi
if [ -n "${reference}" ]; then runthis="$runthis --ref-genome-fasta ${reference}"; fi
if [ -n "${filter-min-length}" ]; then runthis="$runthis --filter-min-length ${filter-min-length}"; fi
if [ -n "${filter-min-expr}" ]; then runthis="$runthis --filter-min-expr ${filter-min-expr}"; fi
if [ -n "${isoform-frac}" ]; then runthis="$runthis --isoform-frac ${isoform-frac}"; fi
if [ -n "${max-isoforms}" ]; then runthis="$runthis --max-isoforms ${max-isoforms}"; fi

Input=$(basename ${seqFolder});

	echo "Trnascript merging"
	
	ls $Input/* > gtf.list
	/opt/apps/taco/taco_run $runthis gtf.list
	/opt/apps/taco/taco_refcomp -o taco_refcomp -r "${annotation}" -t "${output_file}"/assembly.gtf 
	rm -rf Taco_merge_test.sh
	rm -rf "${seqFolder}" "${reference}" "${annotation}"
trap "rm -rf ${seqFolder} ${reference} ${annotation}" exit

