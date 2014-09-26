GTF=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf

htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/Ctl-1.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/Ctl-1_counts.txt &
htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/Ctl-4.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/Ctl-4_counts.txt &
htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/Ctl-5.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/Ctl-5_counts.txt &
htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/HMGB1-1.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/HMGB1-1_counts.txt &
htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/HMGB1-4.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/HMGB1-4_counts.txt &
htseq-count -f bam -r pos -s no -m intersection-nonempty -q /media/e/gre_10036_rna/bams/HMGB1-5.sorted.bam $GTF > /media/e/gre_10036_rna/htseq-count/HMGB1-5_counts.txt &
