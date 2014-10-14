QUALIMAP=/home/rgarcia/Downloads/qualimap_v2.0/qualimap
GTF=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf

$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-1.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/Ctl-1.2500.counts
$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-4.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/Ctl-4.2500.counts
$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/Ctl-5.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/Ctl-5.2500.counts
$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-1.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/HMGB1-1.2500.counts
$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-4.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/HMGB1-4.2500.counts
$QUALIMAP comp-counts -s name -pe -gtf $GTF -bam /media/e/gre_10036_rna/bams/HMGB1-5.paired_isized_2500.bam -out /media/e/gre_10036_rna/qualimap_counts/HMGB1-5.2500.counts
