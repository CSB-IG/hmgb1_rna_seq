CUFFQUANT=/media/e/gre_10036_rna/cufflinks-2.2.1.Linux_x86_64/cuffquant
GTF=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf
BAMS=/media/e/gre_10036_rna/bams

$CUFFQUANT -p 24 -o quantification $GTF \
           ${BAMS}/Ctl-1.merged.bam,${BAMS}/Ctl-4.merged.bam,${BAMS}/Ctl-5.merged.bam \
           ${BAMS}/HMGB1-1.merged.bam,${BAMS}/HMGB1-4.merged.bam,${BAMS}/HMGB1-5.merged.bam
