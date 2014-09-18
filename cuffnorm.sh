CUFFNORM=/media/e/gre_10036_rna/cufflinks-2.2.1.Linux_x86_64/cuffnorm
GTF=/media/e/gre_10036_rna/Human-gencode.v19/gencode.v19.annotation.gtf

CXB=/media/e/gre_10036_rna/2014-9_cufflinks/quantification/abundances.cxb

$CUFFNORM -p 24 -o normalization $GTF $CXB 

