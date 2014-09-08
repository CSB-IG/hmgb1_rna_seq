BAMS=/media/e/gre_10036_rna/bams
CUFFLINKS=/media/e/gre_10036_rna/cufflinks-2.2.1.Linux_x86_64/cufflinks
GTF_ann=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf
GTF_guide=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.tRNAs.gtf

$CUFFLINKS -g $GTF_guide -G $GTF_ann -p 24 -o Ctl-1 ${BAMS}/Ctl-1.merged.bam
$CUFFLINKS -g $GTF_guide --G=$GTF_ann -p 24 -o Ctl-4 ${BAMS}/Ctl-4.merged.bam
$CUFFLINKS -g $GTF_guide --G=$GTF_ann -p 24 -o Ctl-5 ${BAMS}/Ctl-5.merged.bam
$CUFFLINKS -g $GTF_guide --G=$GTF_ann -p 24 -o HMGB1-1 ${BAMS}/HMGB1-1.merged.bam
$CUFFLINKS -g $GTF_guide --G=$GTF_ann -p 24 -o HMGB1-4 ${BAMS}/HMGB1-4.merged.bam
$CUFFLINKS -g $GTF_guide --G=$GTF_ann -p 24 -o HMGB1-5 ${BAMS}/HMGB1-5.merged.bam
