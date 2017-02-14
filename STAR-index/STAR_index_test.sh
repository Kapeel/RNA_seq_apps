#!/bin/bash

#Get STAR binary
git clone https://github.com/alexdobin/STAR.git
export PATH=$PATH:./STAR/bin/Linux_x86_64_static/

#wrapper script for STAR index
reference="Sbicolor.fa"
annotation="Sbicolor_255_v2.1.gene.gtf"

mkdir index
STAR --runThreadN 4 --runMode genomeGenerate  --genomeDir index --genomeFastaFiles "${reference}" --sjdbGTFfile "${annotation}"

