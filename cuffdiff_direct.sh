BAMS=/media/e/gre_10036_rna/bams

CUFFDIFF=/media/e/gre_10036_rna/cufflinks-2.2.1.Linux_x86_64/cuffdiff

GTF_ann=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf
GTF_guide=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.tRNAs.gtf

$CUFFDIFF -o diff -p 24 $GTF_ann ${BAMS}/Ctl-1.merged.bam,${BAMS}/Ctl-4.merged.bam,${BAMS}/Ctl-5.merged.bam \
          ${BAMS}/HMGB1-1.merged.bam,${BAMS}/HMGB1-4.merged.bam,${BAMS}/HMGB1-5.merged.bam
