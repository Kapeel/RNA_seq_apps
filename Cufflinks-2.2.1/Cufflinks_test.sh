#!/bin/bash

#Get Cufflinks binary
#tar -xvf cufflinks-2.2.1.Linux_x86_64.tar.gz
export PATH=$PATH:./cufflinks-2.2.1.Linux_x86_64/

#wrapper script for StringTie
annotation="Sbicolor_255_v2.1.gene.gtf"
reference=""
seqFolder="bam"
library_type="fr-unstranded"
mkdir Cufflinks_output gtf_output
#frag_len_mean="${frag_len_mean}"
frag_len_mean="200"
#frag_len_std_dev="${frag_len_std_dev}"
frag_len_std_dev="80"
#max_mle_iterations#="${max_mle_iterations}"
max_mle_iterations="5000"
#label="${label}"
label="CUFF"
#min_isoform_fraction="${min_isoform_fraction}"
min_isoform_fraction="0.10"
#pre_mrna_fraction="${pre_mrna_fraction}"
pre_mrna_fraction="0.15"
#max_intron_length="${max_intron_length}"
max_intron_length="300000"
#min_frags_per_transfrag="${min_frags_per_transfrag}"
min_frags_per_transfrag="0.10"
#overhang_tolerance="${overhang_tolerance}"
overhang_tolerance="8"
#min_intron_length="${min_intron_length}"
min_intron_length="50"
#max_multiread_fraction="${max_multiread_fraction}"
max_multiread_fraction="0.75"
#overlap_radius="${overlap_radius}"
overlap_radius="50"

runthis=''


if [ -n "${annotation}" ]; then runthis="$runthis -g ${annotation} "; fi
if [ -n "${reference}" ]; then runthis="$runthis -b ${reference}"; fi
if [ -n "${library_type}" ]; then runthis="$runthis --library-type ${library_type}"; fi
if [ -n "${frag_len_mean}" ]; then runthis="$runthis -m ${frag_len_mean}"; fi
if [ -n "${frag_len_std_dev}" ]; then runthis="$runthis -s ${frag_len_std_dev}"; fi
if [ -n "${max_mle_iterations}" ]; then runthis="$runthis --max-mle-iterations ${max_mle_iterations}"; fi
if [ -n "${label}" ]; then runthis="$runthis -L ${label}"; fi
if [ -n "${min_isoform_fraction}" ]; then runthis="$runthis --min-isoform-fraction ${min_isoform_fraction}"; fi
if [ -n "${pre_mrna_fraction}" ]; then runthis="$runthis --pre-mrna-fraction ${pre_mrna_fraction}"; fi
if [ -n "${max_intron_length}" ]; then runthis="$runthis --min-intron-length ${max_intron_length}"; fi
if [ -n "${min_frags_per_transfrag}" ]; then runthis="$runthis --min-frags-per-transfrag ${min_frags_per_transfrag}"; fi
if [ -n "${overhang_tolerance}" ]; then runthis="$runthis --overhang-tolerance ${overhang_tolerance}"; fi
if [ -n "${min_intron_length}" ]; then runthis="$runthis --min-intron-length ${min_intron_length}"; fi
if [ -n "${max_multiread_fraction}" ]; then runthis="$runthis --max-multiread-fraction ${max_multiread_fraction}"; fi
if [ -n "${overlap_radius}" ]; then runthis="$runthis --overlap-radius ${overlap_radius}"; fi

Input=$(basename ${seqFolder});

	echo "Transcript assembly by StringTie"
	
	for x in $Input/*
	do
	if [[ "$x" =~ .*\.bam$ ]];
        then 
	z=$(basename $x .bam)
		 echo "file of this interation $x"
		 echo "$runthis"
		 cufflinks "$x" $runthis -p 4 -o "$z"
        mv "$z"* Cufflinks_output
	rsync -av --progress Cufflinks_output/"$z"/transcripts.gtf gtf_output
	mv gtf_output/transcripts.gtf gtf_output/"$z"".gtf"
	fi
	done

#rm -rf STAR-2.5.2b STAR_align_wrapper.sh
#rm -rf "${seqFolder}"
