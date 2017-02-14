#!/bin/bash

#Get StringTie binary
#tar -xvf stringtie-1.3.1c.Linux_x86_64.tar.gz
export PATH=$PATH:./stringtie-1.3.1c.Linux_x86_64/


#wrapper script for StringTie
annotation="Sbicolor_255_v2.1.gene.gtf"
seqFolder="STAR_bam"
#compression_type="gzipped"
mkdir StringTie_output gtf_output
#min_isof_abund="${min_isof_abund}"
min_isof_abund="0.3"
#min_len_trans="${min_len_trans}"
min_len_trans=200
#junc_bases="${junc_bases}"
junc_bases=10
#no_spice_reads="${no_spice_reads}"
no_spice_reads=1
#min_read_cov="${min_read_cov}"
min_read_cov=2.5
#min_locus_gap="${min_locus_gap}"
min_locus_gap=50
#max_frac_multi_reads="${max_frac_multi_reads}"
max_frac_multi_reads=0.95
enable_bgwn=true
ref_gtf=true

echo $enable_bgwn
echo $ref_gtf

runthis=''


if [ -n "${annotation}" ]; then runthis="$runthis -G ${annotation} -A "gene_abund.tab" -C "cov_refs.gtf" "; fi
if [ -n "${min_isof_abund}" ]; then runthis="$runthis -f ${min_isof_abund}"; fi
if [ -n "${min_len_trans}" ]; then runthis="$runthis -m ${min_len_trans}"; fi
if [ -n "${junc_bases}" ]; then runthis="$runthis -a ${junc_bases}"; fi
if [ -n "${no_spice_reads}" ]; then runthis="$runthis -j ${no_spice_reads}"; fi
if [ -n "${min_read_cov}" ]; then runthis="$runthis -c ${min_read_cov}"; fi
if [ -n "${min_locus_gap}" ]; then runthis="$runthis -g ${min_locus_gap}"; fi
if [ -n "${max_frac_multi_reads}" ]; then runthis="$runthis -M ${max_frac_multi_reads}"; fi
if [ "$enable_bgwn"=true ]; then runthis="$runthis -B"; mkdir ballgown_input_files; fi
if [ "$ref_gtf"=true ]; then runthis="$runthis -e"; fi

Input=$(basename ${seqFolder});

	echo "Trnascript assembly by StringTie"
	
	for x in $Input/*
	do
	if [[ "$x" =~ .*\.bam$ ]];
        then 
	z=$(basename $x .bam)
		 echo "file of this interation $x"
		 echo "$runthis"
		 stringtie "$x" $runthis -p 4 -o "$z"".gtf"
	mkdir StringTie_output/"$z"
        mv "$z"* *abund.tab *refs.gtf StringTie_output/"$z"
	rsync -av --progress StringTie_output/"$z"/"$z"".gtf" gtf_output
	if [ "$enable_bgwn"=true ]; 
	then
		mkdir ballgown_input_files/"$z"
		mv *ctab ballgown_input_files/"$z"	
	fi

	fi
	done
zip -r ballgown_input_files.zip ballgown_input_files
#rm -rf STAR-2.5.2b STAR_align_wrapper.sh
#rm -rf "${seqFolder}"
trap "rm -rf ${seqFolder} stringtie-1.3.1c.Linux_x86_64 StringTie_wrapper.sh gtf_output StringTie_output ballgown_input_files* ${annotation} ${reference}" exit
