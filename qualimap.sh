QUALIMAP=/home/rgarcia/Downloads/qualimap_v1.0/qualimap
GTF=/media/e/gre_10036_rna/iGenome/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf

$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-1.merged.bam -outdir /media/e/gre_10036_rna/qualimap/Ctl-1.merged.bam 
$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-4.merged.bam -outdir /media/e/gre_10036_rna/qualimap/Ctl-4.merged.bam 
$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-5.merged.bam -outdir /media/e/gre_10036_rna/qualimap/Ctl-5.merged.bam 
$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-1.merged.bam -outdir /media/e/gre_10036_rna/qualimap/HMGB1-1.merged.bam 
$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-4.merged.bam -outdir /media/e/gre_10036_rna/qualimap/HMGB1-4.merged.bam 
$QUALIMAP rnaseq -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-5.merged.bam -outdir /media/e/gre_10036_rna/qualimap/HMGB1-5.merged.bam 
