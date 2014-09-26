# grep only proper paired reads, flag: 2

samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/Ctl-1.paired.bam /media/e/gre_10036_rna/bams/Ctl-1.merged.bam &
samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/Ctl-4.paired.bam /media/e/gre_10036_rna/bams/Ctl-4.merged.bam &
samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/Ctl-5.paired.bam /media/e/gre_10036_rna/bams/Ctl-5.merged.bam &
samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/HMGB1-1.paired.bam /media/e/gre_10036_rna/bams/HMGB1-1.merged.bam &
samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/HMGB1-4.paired.bam /media/e/gre_10036_rna/bams/HMGB1-4.merged.bam &
samtools view -f 2 -b -h -o /media/e/gre_10036_rna/bams/HMGB1-5.paired.bam /media/e/gre_10036_rna/bams/HMGB1-5.merged.bam &
