#!/bin/bash

tar -xvf tophat-2.1.1.Linux_x86_64.tar.gz
unzip bowtie2-2.2.9-linux-x86_64.zip
export PATH=$PATH:./tophat-2.1.1.Linux_x86_64/:./bowtie2-2.2.9/bowtie2/

#wrapper script for Tophat2 index align
annotation="${annotation}"
reference="${reference}"
seqmode="${seqmode}"
seqFolder="${seqFolder}"
rna_strandness="${rna_strandness}"
#rna_strandness="fr-unstranded"
mate_inner_dist="${mate_inner_dist}"
#mate_inner_dist=50
min_anchor_length="${min_anchor_length}"
#min_anchor_length=8
splice_mismatches="${splice_mismatches}"
#splice_mismatches=0
min_intron_length="${min_intron_length}"
#min_intron_length=70
max_intron_length="${max_intron_length}"
#max_intron_length=50000
min_isoform_fraction="${min_isoform_fraction}"
#min_isoform_fraction=0.15
max_multihits="${max_multihits}"
#max_multihits=20
min_segment_intron="${min_segment_intron}"
#min_segment_intron=50
max_segment_intron="${max_segment_intron}"
#max_segment_intron=500000
segment_mismatches="${segment_mismatches}"
#segment_mismatches=2
segment_length="${segment_length}"
#segment_length=20
read_mismatches="${read_mismatches}"
#read_mismatches=2
read_gap_length="${read_gap_length}"
#read_gap_length=2
read_edit_dist="${read_edit_dist}"
#read_edit_dist=2
mate_std_dev="${mate_std_dev}"
#mate_std_dev=20
runthis=''

if [ -n "${annotation}" ]; then runthis="$runthis -G ${annotation}"; fi
if [ -n "${rna_strandness}" ]; then runthis="$runthis --library-type ${rna_strandness}"; fi
if [ -n "${mate_inner_dist}" ]; then runthis="$runthis --mate-inner-dist ${mate_inner_dist}"; fi
if [ -n "${min_anchor_length}" ]; then runthis="$runthis --min-anchor-length ${min_anchor_length}"; fi
if [ -n "${splice_mismatches}" ]; then runthis="$runthis --splice-mismatches ${splice_mismatches}"; fi
if [ -n "${min_intron_length}" ]; then runthis="$runthis --min-intron-length ${min_intron_length}"; fi
if [ -n "${max_intron_length}" ]; then runthis="$runthis --max-intron-length ${max_intron_length}"; fi
if [ -n "${min_isoform_fraction}" ]; then runthis="$runthis --min-isoform-fraction ${min_isoform_fraction}"; fi
if [ -n "${max_multihits}" ]; then runthis="$runthis --max-multihits ${max_multihits}"; fi
if [ -n "${min_segment_intron}" ]; then runthis="$runthis --min-segment-intron ${min_segment_intron}"; fi
if [ -n "${max_segment_intron}" ]; then runthis="$runthis --max-segment-intron ${max_segment_intron}"; fi
if [ -n "${segment_mismatches}" ]; then runthis="$runthis --segment-mismatches ${segment_mismatches}"; fi
if [ -n "${segment_length}" ]; then runthis="$runthis --segment-length ${segment_length}"; fi
if [ -n "${read_mismatches}" ]; then runthis="$runthis --read-mismatches ${read_mismatches}"; fi
if [ -n "${read_gap_length}" ]; then runthis="$runthis --read-gap-length ${read_gap_length}"; fi
if [ -n "${read_edit_dist}" ]; then runthis="$runthis --read-edit-dist ${read_edit_dist}"; fi
if [ -n "${mate_std_dev}" ]; then runthis="$runthis --mate-std-dev ${mate_std_dev}"; fi


Input=$(basename ${seqFolder});
y=$(basename ${reference%.*})
bowtie2-build ${reference} $y
mkdir index output bam
mv $y*bt2 index
if [ $seqmode = paired ];
then
	echo "Paired end mode"

	for x in $Input/*
	do
		 if [[ "$x" =~ .*1\.gz$ ]];
                then
                z=$(basename $x 1.gz)
                        echo "file of this interation $z"1.gz" $z"2.gz""
			tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.gz' "$Input"/"$z"'2.gz'	        
		mv "$z"* output
		rsync -av --progress output/"$z"/accepted_hits.bam bam
		mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.fastq\.gz$ ]];
                then
		z=$(basename $x 1.fastq.gz)
                        echo "file of this interation $z"1.gz" $z"2.gz""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.fastq.gz' "$Input"/"$z"'2.fastq.gz'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.fq\.gz$ ]];
                then
		z=$(basename $x 1.fq.gz)
                        echo "file of this interation $z"1.gz" $z"2.gz""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.fq.gz' "$Input"/"$z"'2.fq.gz'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.bz2$ ]];
                then
		z=$(basename $x 1.bz2)
                        echo "file of this interation $z"1.bz2" $z"2.bz2""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.bz2' "$Input"/"$z"'2.bz2'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.fastq\.bz2$ ]];
                then
		z=$(basename $x 1.fastq.bz2)
                        echo "file of this interation $z"1.fastq.bz2" $z"2.fastq.bz2""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.fastq.bz2' "$Input"/"$z"'2.fastq.bz2'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.fq\.bz2$ ]];
                then
		z=$(basename $x 1.fq.bz2)
                        echo "file of this interation $z"1.fq.bz2" $z"2.fq.bz2""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.fq.bz2' "$Input"/"$z"'2.fq.bz2'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi
		if [[ "$x" =~ .*1\.fastq$ ]];
                then
		z=$(basename $x 1.fastq)
                        echo "file of this interation $z"1.fastq" $z"2.fastq""
                        tophat2 -p 4 -o "$z" $runthis index/$y "$Input"/"$z"'1.fastq' "$Input"/"$z"'2.fastq'
                mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
                fi

	done
fi

if [ $seqmode = single ];
then
	echo "single end mode"
	
	for x in $Input/*
	do
		z=$(basename ${x%.*})
		echo "file of this interation $x"
		tophat2 -p 4 -o "$z" $runthis index/$y $x
		mv "$z"* output
                rsync -av --progress output/"$z"/accepted_hits.bam bam
                mv bam/accepted_hits.bam bam/"$z".bam
	done
fi

rm -rf tophat-2.1.1.Linux_x86_64 bowtie2-2.2.9 
rm -rf "${seqFolder}" "${annotation}"
