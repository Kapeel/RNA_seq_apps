#!/bin/bash

#Get StringTie binary
tar -xvf stringtie-1.3.1c.Linux_x86_64.tar.gz
export PATH=$PATH:./stringtie-1.3.1c.Linux_x86_64/

#wrapper script for StringTie
annotation="${annotation}"
seqFolder="${seqFolder}"

output_file="${output_file}"
#output_file="merged_out"
min_trans_len="${min_trans_len}"
#min_trans_len=50
min_trans_cov="${min_trans_cov}"
#min_trans_cov=0
min_FPKM="${min_FPKM}"
#min_FPKM=0
min_TPM="${min_TPM}"
#min_TPM=0
min_isf_frac="${min_isf_frac}"
#min_isf_frac=0.01
runthis=''


if [ -n "${annotation}" ]; then runthis="$runthis -G ${annotation}"; fi
if [ -n "${min_trans_len}" ]; then runthis="$runthis -m ${min_trans_len}"; fi
if [ -n "${min_trans_cov}" ]; then runthis="$runthis -c ${min_trans_cov}"; fi
if [ -n "${min_FPKM}" ]; then runthis="$runthis -F ${min_FPKM}"; fi
if [ -n "${min_TPM}" ]; then runthis="$runthis -T ${min_TPM}"; fi
if [ -n "${min_isf_frac}" ]; then runthis="$runthis -f ${min_isf_frac}"; fi
if [ -n "${output_file}" ]; then runthis="$runthis -o ${output_file}"; fi

Input=$(basename ${seqFolder});

	echo "Trnascript merging"
	
	ls $Input/* > gtf.list
	stringtie --merge $runthis gtf.list
    
rm -rf StringTie_merge_wrapper.sh stringtie-1.3.1c.Linux_x86_64
rm -rf "${seqFolder}" "${annotation}"
trap "rm -rf ${seqFolder} stringtie-1.3.1c.Linux_x86_64 StringTie_merge_wrapper.sh gtf.list merged_out ${annotation} ${reference}" exit
