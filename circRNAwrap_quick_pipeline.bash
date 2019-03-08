# circRNAwrap pipeline

sample=$1

# alignment, identification, transcript prediction, abundance estimation

# software
ciri_as="/home/lilin/workdir/git/CIRI-full_v2.0/bin/CIRI_AS_v1.2/CIRI_AS_v1.2.pl"
ciri=/home/lilin/workdir/git/CIRI-full_v2.0/bin/CIRI_v2.0.6/CIRI2.pl
sailfish_cir="/home/lilin/workdir/git/sailfish-cir/sailfish_cir.py"
# reference
genome=/home/lilin/workdir/reference/gatk4/hg19_ref/ucsc.hg19.fasta  # include bwa faidx file
GTF=/home/lilin/workdir/reference/gatk4/hg19_ref/hg19_genes.gtf  
REF="/home/lilin/workdir/reference/gatk4/hg19_ref/annotation/hg19_gene.txt"

cd $dir/${sample}
# fastq are same length, not trimmed reads
echo "CIRI-AS begin" && echo ${sample} && date
mkdir ${sample}_CIRI-AS
#time fastq-dump --split-3 $sra/${sample}.sra
time bwa mem -t 4 -T 19 $genome ./${sample}_1.fastq ./${sample}_2.fastq > ./${sample}.bwa.sam
time perl $ciri -T 5 -I ./${sample}.bwa.sam -F $genome -A $GTF -G ./${sample}_CIRI-AS/${sample}.log -O ./${sample}_CIRI-AS/${sample}.CIRI.txt
time perl $ciri_as -S ${sample}.bwa.sam -C ./${sample}_CIRI-AS/${sample}.CIRI.txt -O ./${sample}_CIRI-AS/${sample}.CIRI.sequence -F $genome -A $GTF
rm ${sample}.bwa.sam
rm ${sample}_1.fastq
rm ${sample}_2.fastq
echo "CIRI-AS done" && echo ${sample} && date