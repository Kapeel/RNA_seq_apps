#!/bin/bash

unzip hisat2-2.0.4-Linux_x86_64.zip
export PATH=$PATH:./hisat2-2.0.4/

#wrapper script for HISAT2 index align
reference="Sbicolor.fa"
seqmode="single"
seqFolder="testformat2"
#rna_strandness="${rna_strandness}"
rna_strandness="FR"
#trim_bases_5="${trim_bases_5}"
trim_bases_5=0
#trim_bases_3="${trim_bases_3}"
trim_bases_3=0
#min_int_len="${min_int_len}"
min_int_len=20
#max_int_len="${max_int_len}"
max_int_len=500000
runthis=''

if [ -n "${rna_strandness}" ]; then runthis="$runthis --rna-strandness ${rna_strandness}"; fi
if [ -n "${trim_bases_5}" ]; then runthis="$runthis -5 ${trim_bases_5}"; fi
if [ -n "${trim_bases_3}" ]; then runthis="$runthis -3 ${trim_bases_3}"; fi
if [ -n "${min_int_len}" ]; then runthis="$runthis --min-intronlen ${min_int_len}"; fi
if [ -n "${max_int_len}" ]; then runthis="$runthis --max-intronlen ${max_int_len}"; fi


Input=$(basename ${seqFolder});
y=$(basename ${reference%.*})
hisat2-build ${reference} $y
mkdir index output
mv $y*ht2 index

if [ $seqmode = paired ];
then
	echo "Paired end mode"

	for x in $Input/*
	do
		 if [[ "$x" =~ .*1\.gz$ ]];
                then
                z=$(basename $x 1.gz)
                        echo "file of this interation $z"1.gz" $z"2.gz""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.gz' -2 "$Input"/"$z"'2.gz' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.fastq\.gz$ ]];
                then
                z=$(basename $x 1.fastq.gz)
                        echo "file of this interation $z"1.fastq.gz" $z"2.fastq.gz""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.fastq.gz' -2 "$Input"/"$z"'2.fastq.gz' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.fq\.gz$ ]];
                then
                z=$(basename $x 1.fq.gz)
                        echo "file of this interation $z"1.fq.gz" $z"2.fq.gz""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.fq.gz' -2 "$Input"/"$z"'2.fq.gz' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.bz2$ ]];
                then
                z=$(basename $x 1.bz2)
                        echo "file of this interation $z"1.bz2" $z"2.bz2""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.bz2' -2 "$Input"/"$z"'2.bz2' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.fastq\.bz2$ ]];
                then
                z=$(basename $x 1.fastq.bz2)
                        echo "file of this interation $z"1.fastq.bz2" $z"2.fastq.bz2""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.fastq.bz2' -2 "$Input"/"$z"'2.fastq.bz2' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.fq\.bz2$ ]];
                then
                z=$(basename $x 1.fq.bz2)
                        echo "file of this interation $z"1.fq.bz2" $z"2.fq.bz2""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.fq.bz2' -2 "$Input"/"$z"'2.fq.bz2' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
                fi
		if [[ "$x" =~ .*1\.fastq$ ]];
                then
                z=$(basename $x 1.fastq)
                        echo "file of this interation $z"1.fastq" $z"2.fastq""
                        hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -1 "$Input"/"$z"'1.fastq' -2 "$Input"/"$z"'2.fastq' | samtools view -bS - | samtools sort - "$z".sorted
                        mv "$z"* output
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
		hisat2 $runthis -p 16 --dta-cufflinks -x index/$y -U $x | samtools view -bS - | samtools sort - "$z".sorted
		mv "$z"* output
	done
fi

