CUFFMERGE=cufflinks-2.2.1.Linux_x86_64/cuffmerge
ANN=merged_asm/merged.gtf

$CUFFMERGE -p 24 -o Ctl-1_quant $ANN bams/Ctl-1.merged.bam
$CUFFMERGE -p 24 -o Ctl-4_quant $ANN bams/Ctl-4.merged.bam
$CUFFMERGE -p 24 -o Ctl-5_quant $ANN bams/Ctl-5.merged.bam
$CUFFMERGE -p 24 -o HMGB1-1_quant $ANN bams/HMGB1-1.merged.bam
$CUFFMERGE -p 24 -o HMGB1-4_quant $ANN bams/HMGB1-4.merged.bam
$CUFFMERGE -p 24 -o HMGB1-5_quant $ANN bams/HMGB1-5.merged.bam
