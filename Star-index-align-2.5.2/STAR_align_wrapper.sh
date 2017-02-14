#!/bin/bash

#Get STAR binary
#git clone https://github.com/alexdobin/STAR.git
tar -xvf 2.5.2b.tar.gz
export PATH=$PATH:./STAR-2.5.2b/bin/Linux_x86_64_static/

#wrapper script for STAR index
reference="${reference}"
annotation="${annotation}"
seqmode="${seqmode}"
seqFolder="${seqFolder}"
mkdir index output
outFilterType="${outFilterType}"
outFilterMultimapNmax="${outFilterMultimapNmax}"
alignSJoverhangMin="${alignSJoverhangMin}"
alignSJDBoverhangMin="${alignSJDBoverhangMin}"
outFilterMismatchNmax="${outFilterMismatchNmax}"
alignIntronMin="${alignIntronMin}"
alignIntronMax="${alignIntronMax}"
alignMatesGapMax="${alignMatesGapMax}"
runthis=''

if [ -n "${annotation}" ]; then runthis="$runthis --sjdbGTFfile ${annotation}"; fi
if [ -n "${outFilterType}" ]; then runthis="$runthis --outFilterType ${outFilterType}"; fi
if [ -n "${outFilterMultimapNmax}" ]; then runthis="$runthis --outFilterMultimapNmax ${outFilterMultimapNmax}"; fi
if [ -n "${alignSJoverhangMin}" ]; then runthis="$runthis --alignSJoverhangMin ${alignSJoverhangMin}"; fi
if [ -n "${alignSJDBoverhangMin}" ]; then runthis="$runthis --alignSJDBoverhangMin ${alignSJDBoverhangMin}"; fi
if [ -n "${outFilterMismatchNmax}" ]; then runthis="$runthis --outFilterMismatchNmax ${outFilterMismatchNmax}"; fi
if [ -n "${alignIntronMin}" ]; then runthis="$runthis --alignIntronMin ${alignIntronMin}"; fi
if [ -n "${alignIntronMax}" ]; then runthis="$runthis --alignIntronMax ${alignIntronMax}"; fi
if [ -n "${alignMatesGapMax}" ]; then runthis="$runthis --alignMatesGapMax ${alignMatesGapMax}"; fi

STAR --runThreadN 4 --runMode genomeGenerate  --genomeDir index --genomeFastaFiles "${reference}"

Input=$(basename ${seqFolder});

if [ $seqmode = paired ];
then
	echo "Paired end mode"

	for x in $Input/*
	do
		if [[ "$x" =~ .*1\.gz$ ]];
		then
		z=$(basename $x 1.gz)
			echo "file of this interation $z"1.gz" $z"2.gz""
			STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.gz' "$Input"/"$z"'2.gz' --readFilesCommand gunzip -c --outFileNamePrefix "$z"  --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
			mkdir output/"$z"
                        mv "$z"* output/"$z"
		fi
		if [[ "$x" =~ .*1\.bz2$ ]];
                then
		z=$(basename $x 1.bz2)
			echo "file of this interation $z"1.bz2" $z"2.bz2""
		        STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.bz2' "$Input"/"$z"'2.bz2' --readFilesCommand bunzip2 -c --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
                        mkdir output/"$z"
                        mv "$z"* output/"$z"
                fi
		if [[ "$x" =~ .*1\.fastq$ ]];
		then
		z=$(basename $x 1.fastq)
		        echo "file of this interation $z"1.fastq" $z"2.fastq""
			STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fastq' "$Input"/"$z"'2.fastq' --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
			mkdir output/"$z"
                        mv "$z"* output/"$z"
		fi
		if [[ "$x" =~ .*1\.fq$ ]];
                then
		z=$(basename $x 1.fq)
		       echo "file of this interation $z"1.fq" $z"2.fq""
		       STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fq' "$Input"/"$z"'2.fq' --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
		       mkdir output/"$z"
                       mv "$z"* output/"$z"
                fi
		if [[ "$x" =~ .*1\.fastq.gz$ ]];
                then
		z=$(basename $x 1.fastq.gz)
		       echo "file of this interation $z"1.fastq.gz" $z"2.fastq.gz""
		       STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fastq.gz' "$Input"/"$z"'2.fastq.gz' --readFilesCommand gunzip -c --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
                       mkdir output/"$z"
                       mv "$z"* output/"$z"
                fi
		if [[ "$x" =~ .*1\.fastq.bz2$ ]];
                then
		z=$(basename $x 1.fastq.bz2)
			echo "file of this interation $z"1.fastq.bz2" $z"2.fastq.bz2""
		        STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fastq.bz2' "$Input"/"$z"'2.fastq.bz2' --readFilesCommand bunzip2 -c --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
                       mkdir output/"$z"
                       mv "$z"* output/"$z" 
                fi
		if [[ "$x" =~ .*1\.fq.gz$ ]];
                then
		z=$(basename $x 1.fq.gz)
		        echo "file of this interation $z"1.fq.gz" $z"2.fq.gz""
			STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fq.gz' "$Input"/"$z"'2.fq.gz' --readFilesCommand gunzip -c --outFileNamePrefix "$z"  --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
                       mkdir output/"$z"
                       mv "$z"* output/"$z"
                fi
		if [[ "$x" =~ .*1\.fq.bz2$ ]];
                then
		z=$(basename $x 1.fq.bz2)
		        echo "file of this interation $z"1.fq.bz2" $z"2.fq.bz2""
			STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$Input"/"$z"'1.fq.bz2' "$Input"/"$z"'2.fq.bz2' --readFilesCommand bunzip2 -c --outFileNamePrefix "$z" --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
                mkdir output/"$z"
                mv "$z"* output/"$z"
		fi
	done
	mkdir bam_output
        rsync -av --progress output/*/*bam bam_output
fi

if [ $seqmode = single ];
then
	echo "single end mode"
	
	for x in $Input/*
	do
	if [[ "$x" =~ .*\.bz2$ ]];
        then 
	z=$(basename $x .bz2)
		 echo "file of this interation $x"
		 STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$x" --readFilesCommand bunzip2 -c --outFileNamePrefix "$z"  --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
	mkdir output/"$z"
        mv "$z"* output/"$z"
	fi
	
	if [[ "$x" =~ .*\.gz$ ]];
        then    
        z=$(basename $x .gz)
                 echo "file of this interation $x"
                 STAR $runthis --runThreadN 4 --genomeDir index --readFilesIn "$x" --readFilesCommand gunzip -c --outFileNamePrefix "$z"  --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outSAMattrIHstart 0 --outSAMstrandField intronMotif
        mkdir output/"$z"
        mv "$z"* output/"$z"
	fi
	done
	mkdir bam_output
	rsync -av --progress output/*/*bam bam_output
	
fi

rm -rf STAR-2.5.2b STAR_align_wrapper.sh 
rm -rf "${seqFolder}"
#trap "rm -rf ${seqFolder} STAR-2.5.2b STAR_align_wrapper.sh output index bam_output ${annotation} ${reference}" exit
trap "rm -rf ${seqFolder} STAR-2.5.2b STAR_align_wrapper.sh ${annotation} ${reference}" exit

