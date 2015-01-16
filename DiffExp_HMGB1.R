##########################################################################################################
##############        Differential Expression and Functional Enrichment for RNA-Seq         ##############
##############                         data: HMGB1                                          ##############
##########################################################################################################

###Authors
###Jesús Espinal-Enríquez and Rodrigo García-Herrera
source("http://bioconductor.org/biocLite.R")
 biocLite("edgeR")
setwd("~/Dropbox/RawCountsNotron")
myRaw = read.delim("ine_collapsed.txt", header = TRUE, as.is = TRUE, row.names = 1, sep = " ")
head(myRaw)
dim(myRaw)


# myRaw = myRaw[, grep(".D", colnames(myRaw), fixed = TRUE)]
myRaw = myRaw[,order(colnames(myRaw))]
 tail(myRaw)

## Biological annotation (from Biomart)
biomart = read.delim("BiomartUniq.txt", header = TRUE, as.is = TRUE, row.names = 1)
 tail(biomart)
head(biomart)
biomart1 = read.delim("BiomartUniq.txt", header = TRUE, as.is = TRUE)
##*****************************************************##

#### 1) EXPLORATORY ANALYSIS (NOISeq package)

# biocLite("NOISeq")
library(NOISeq)


mybiotypes = biomart[(2)]
head(mybiotypes)

mychroms = biomart[,3:5]
rownames(mychroms) = row.names(biomart)
colnames(mychroms) = c("Chr", "GeneStart", "GeneEnd")
head(mychroms)


myGC = biomart[(1)]
head(myGC)
##En esta dices cuantos son los grupos, en each
myfactors = data.frame("group" = substr(colnames(myRaw), start = 1, stop = 1)
                       #                        , "day" = substr(colnames(myRaw), start = 2, stop = 2)
)
# myfactors
 myfactors = data.frame(myfactors, "cond" = apply(myfactors, 1, paste, collapse = "_"))
# myfactors = data.frame("group" = as.factor(rep(c("E","S"), each=9)))

 myfactors
mylength = biomart[(6)]
head(mylength)

mydata = NOISeq::readData(data = myRaw, length = mylength, biotype = mybiotypes, chromosome = mychroms, factors = myfactors, gc = myGC)

#############################################
#############################################


##########################################
####TODO ESTO VA EN EL QCreport ##########
##########################################
## Biodetection plot
mybiodetection <- NOISeq::dat(mydata, type = "biodetection", factor = "group", k = 10)
par(mfrow = c(1,2))
explo.plot(mybiodetection)
## Count distribution per biotype
mycountsbio = NOISeq::dat(mydata, factor = "group", type = "countsbio")
par(mfrow = c(1,2))
explo.plot(mycountsbio, toplot = 1, samples = 1, plottype = "boxplot")
## Saturation plot
mysaturation = dat(mydata, k = 0, ndepth = 7, type = "saturation")
explo.plot(mysaturation, toplot = "protein_coding", samples = c(1,4), yleftlim = NULL, yrightlim = NULL)
## Count distribution per sample
explo.plot(mycountsbio, toplot = "global", samples = NULL, plottype = "boxplot")
explo.plot(mycountsbio, toplot = "global", samples = NULL, plottype = "barplot")
## Length bias detection
mylengthbias = dat(mydata, factor = "group", norm = FALSE, type = "lengthbias")
par(mfrow = c(1,2))
explo.plot(mylengthbias, samples = 1:2)
## RNA composition
mycomp = dat(mydata, norm = FALSE, type = "cd")
explo.plot(mycomp)
########################################
########################################

## Quality Control Report
QCreport(mydata, factor = "group", file = "QCreport_HMGB1_BeforeNorm.pdf")




##*****************************************************##


#####Normalizacion con EDASeq
#############################
# biocLite("ggplot2")
# biocLite("reshape")
library("ggplot2")
library("reshape")
library(EDASeq)


feature <- data.frame(gc=biomart[,1], length=biomart[,6], rownames = row.names(biomart),
                      biotype = biomart[,2], 
                      Chr=biomart[,3],
                      GeneStart=biomart[,4],
                      GeneEnd=biomart[,5])

############
#filtrar por media mayor a un valor
############

#Hacemos que tengan la misma cantidad de filas
myRaw<-myRaw[row.names(myRaw)%in%feature$rownames, ]
feature<-feature[feature$rownames %in%row.names(myRaw), ]

#hacemos que tengan el mismo orden las filas
myRaw<-myRaw[order(row.names(myRaw)),]
feature<-feature[order(feature$rownames),]
row.names(feature)<-feature$rownames
all(row.names(myRaw)==feature$rownames)

#########
#Filtering by  mean < 10 counts
common<- apply(myRaw,1,function(x) mean(x)>10)
table(common)
#FALSE  TRUE 
#16509 17343 

##Filtering low expression genes
feature<-feature[common,]
myRaw<-as.matrix(myRaw[common,])

##Raw data QC
mydataRaw = NOISeq::readData(data=myRaw, 
                             length = feature[,c("rownames","length")], 
                             biotype = feature$mybiotypes, 
                             chromosome = feature[,c("Chr", "GeneStart", "GeneEnd")], 
                             factors = phenoData(mydata)@data, 
                             gc = feature[,c("rownames","gc")])

## Length bias detection
mylengthbiasRaw = NOISeq::dat(mydataRaw,  norm = TRUE, type = "lengthbias")
pdf("UNOBias.pdf")
par(mfrow = c(1,2))
explo.plot(mylengthbiasRaw)

##GCBias
mygcbiasRaw = NOISeq::dat(mydataRaw, norm = TRUE, type = "GCbias")


explo.plot(mygcbiasRaw)
dev.off()
## RNA composition
mycompRaw = NOISeq::dat(mydataRaw, norm = TRUE, type = "cd", refColumn =5)
pdf("UNORNAComp.pdf")
explo.plot(mycompRaw, samples=sample(1:ncol(mydata), 6))
table(mycompRaw@dat$DiagnosticTest[,  "Diagnostic Test"])
dev.off()
#FAILED PASSED 
# 5     0
##Length, gc and RNA content bias detected

##It is necesasary to normalize
##Normalization
data <- EDASeq::newSeqExpressionSet(exprs=myRaw,
                                    featureData=feature,
                                    phenoData=data.frame(
                                      conditions=c(rep("C",3),rep("H",3)),
                                      row.names=colnames(myRaw)))
data
#######NORMALIZATION 
####### TMM -> length -> GC
data2 <- tmm(as.matrix(exprs(data)), long=feature$length)
data2 <- withinLaneNormalization(data2,feature$gc, which="full")
 head(data2)
# C1 C2 C3  H1 H2 H3
# 7SK       8  6  6   7  7  6
# A1BG-AS1  1  1  1   1  1  1
# A2M       0  1  0   1  1  0
# A4GALT   30 77 40  38 71 36
# AAAS     91 86 96 101 80 94
# AACS     34 34 51  31 32 49
mydata = NOISeq::readData(data=data2, 
                          length = feature[,c("rownames","length")], 
                          biotype = feature$mybiotypes, 
                          chromosome = feature[,c("Chr", "GeneStart", "GeneEnd")], 
                          factors = phenoData(data)@data, 
                          gc = feature[,c("rownames","gc")])
## Length bias detection
mylengthbias = NOISeq::dat(mydata, factor = "conditions", norm = TRUE, type = "lengthbias")
pdf("biasPosNorm.pdf")
# par(mfrow = c(1,3))
explo.plot(mylengthbias)
##GCBias
mygcbias = NOISeq::dat(mydata, factor = "conditions", norm = TRUE, type = "GCbias")
#par(mfrow = c(1,2))
explo.plot(mygcbias)
## RNA composition
mycomp = NOISeq::dat(mydata, norm = TRUE, type = "cd", refColumn =5)
explo.plot(mycomp, samples=sample(1:ncol(data2), 6))
 dev.off()
table(mycomp@dat$DiagnosticTest[,  "Diagnostic Test"])
#PASSED 
#5 
write.table(data2, file = "UNONormMatrixRNAseqHMGB1_TMM_length_GC.txt")
# 

##Multidimesional PCA noise analysis
#### 3) NOISE FILTERING
library("NOISeq")
myfilterRawRPKM<-filtered.data(data2, factor="conditions", norm=TRUE, cv.cutoff=1000, cpm=10)
nrow(data2)
#[1] 17343
#[1] "Filtering out low count features..."
#[1] "9461 features are to be kept for differential expression analysis with filtering method 1" cpm=10

pdf("ggplotsNoiseFilteringHMGB1_RPKM.pdf") #####This is performed with filtering cpm = 10
ggplot(data=melt(log(myfilterRawRPKM[ ,sample(1:ncol(myfilterRawRPKM),6)]+1)),aes(y=value, x=X2, group=X2, colour=X2))+geom_boxplot()
ggplot(data=melt(log(myfilterRawRPKM[ ,sample(1:ncol(myfilterRawRPKM), 6)]+1)),aes(x=value, group=X2, colour=X2))+geom_density()

dev.off()


#### 2) PCA EXPLORATION

source("sourceARSyN.R")

#pca.results = PCA.GENES(t(log2(1+data3)))
pca.results = PCA.GENES(t(log2(1+myfilterRawRPKM)))
traditional.pca<-prcomp(t(log2(1+myfilterRawRPKM)))
summary(traditional.pca)

## Variance explained by each component
pdf("PCAvarExpHMGB1_PostNorm.pdf", width = 4*2, height = 4*2)
barplot(pca.results$var.exp[,1], xlab = "PC", ylab = "explained variance", ylim = c(0,0.4))
 dev.off()

## Loading plot
 pdf("UNOEx2_LoadingPlotHMGB1_RPKM.pdf", width = 4*2, height = 4*2)
plot(pca.results$loadings[,1:2], col = 1, pch = 20, cex = 0.5,
     xlab = paste("PC 1 ", round(pca.results$var.exp[1,1]*100,0), "%", sep = ""),
     ylab = paste("PC 2 ", round(pca.results$var.exp[2,1]*100,0), "%", sep = ""),
     main = "PCA loadings",
     xlim = range(pca.results$loadings[,1:2]) + 0.02*diff(range(pca.results$loadings[,1:2]))*c(-1,1),
     ylim = range(pca.results$loadings[,1:2]) + 0.02*diff(range(pca.results$loadings[,1:2]))*c(-1,1))  
 dev.off()


## Score plot

# shapes for the plot
# mypch = rep(c(16,17), each = 6)

myfactors = data.frame("type" = substr(colnames(data2), start = 1, stop = 1))
myfactors$type
myfactors = data.frame(myfactors, "cond" = apply(myfactors, 1, paste, collapse = "_"))
# colors for the plot
mycol = as.character(myfactors$type)
mycol[mycol == 'C'] = "black"
mycol[mycol == 'H'] = "red2"


 pdf("UNOEx2_PCAHMGB1_RPKM.pdf", width = 5*2, height = 5)
par(mfrow = c(1,2))

# PC1 & PC2
rango = diff(range(pca.results$scores[,1:2]))
plot(pca.results$scores[,1:2], col = "white",
     xlab = paste("PC 1 ", round(pca.results$var.exp[1,1]*100,0), "%", sep = ""),
     ylab = paste("PC 2 ", round(pca.results$var.exp[2,1]*100,0), "%", sep = ""),
     main = "PCA scores",
     xlim = range(pca.results$scores[,1:2]) + 0.02*rango*c(-1,1),
     ylim = range(pca.results$scores[,1:2]) + 0.02*rango*c(-1,1))
points(pca.results$scores[,1], pca.results$scores[,2], col = mycol, cex = 1.5)  
legend("topright", unique(as.character(myfactors$type)),), col = rep(unique(mycol),2), ncol = 2)


# PC1 & PC3
rango2 = diff(range(pca.results$scores[,c(1,3)]))
plot(pca.results$scores[,c(1,3)], col = "white",
     xlab = paste("PC 1 ", round(pca.results$var.exp[1,1]*100,0), "%", sep = ""),
     ylab = paste("PC 3 ", round(pca.results$var.exp[3,1]*100,0), "%", sep = ""),
     main = "PCA scores",
     xlim = range(pca.results$scores[,c(1,3)]) + 0.02*rango2*c(-1,1),
     ylim = range(pca.results$scores[,c(1,3)]) + 0.02*rango2*c(-1,1))
points(pca.results$scores[,1], pca.results$scores[,3], col = mycol, cex = 1.5)
legend("topright", unique(as.character(myfactors$type)), col = rep(unique(mycol),2), ncol = 2)

##### We can not  separate both groups by Principal Components
 dev.off()
#########

##Probamos si ArSym reduce el ruido########################################################
myARSyN <- ARSyN(data=log2(myfilterRawRPKM + 1), Covariates=t(as.matrix(myfactors$type)))
head(myARSyN)
#         C1       C2       C3       H1       H2       H3
# A4GALT 4.814870 5.989152 5.793129 5.302852 5.773289 5.588640
# AAAS   6.558529 6.517294 6.490596 6.668046 6.439394 6.474691
# AACS   5.239968 5.364633 5.354404 4.986137 5.359494 5.342619
# AAED1  3.877239 3.936951 3.999592 3.704153 4.237515 4.168163
# AAGAB  6.051852 6.337785 6.186139 6.086529 6.191155 6.265106
# AAMP   7.356772 7.547304 7.478190 7.350915 7.398783 7.410370

pca.results = PCA.GENES(t(myARSyN))
traditional.pca<-prcomp(t(myARSyN))
summary(traditional.pca)

## Variance explained by each component
 pdf("UNOEx2_PCAvarExpARSyN_HMGB1_RPKM.pdf", width = 4*2, height = 4*2)
barplot(pca.results$var.exp[,1], xlab = "PC", ylab = "explained variance", ylim = c(0,0.4))
 dev.off()

## Loading plot
 pdf("UNOEx2_LoadingPlotARSyN_HMGB1_RPKM.pdf", width = 4*2, height = 4*2)
plot(pca.results$loadings[,1:2], col = 1, pch = 20, cex = 0.5,
     xlab = paste("PC 1 ", round(pca.results$var.exp[1,1]*100,0), "%", sep = ""),
     ylab = paste("PC 2 ", round(pca.results$var.exp[2,1]*100,0), "%", sep = ""),
     main = "PCA loadings",
     xlim = range(pca.results$loadings[,1:2]) + 0.02*diff(range(pca.results$loadings[,1:2]))*c(-1,1),
     ylim = range(pca.results$loadings[,1:2]) + 0.02*diff(range(pca.results$loadings[,1:2]))*c(-1,1))  
 dev.off()


## Score plot

# shapes for the plot
# mypch = rep(c(16,17), each = 6)

myfactors = data.frame("type" = substr(colnames(data2), start = 1, stop = 1),
                       "day" = substr(colnames(data2), start = 2, stop = 2)
)
myfactors$type
myfactors = data.frame(myfactors, "cond" = apply(myfactors, 1, paste, collapse = "_"))
# colors for the plot
mycol = as.character(myfactors$type)
mycol[mycol == 'C'] = "black"
mycol[mycol == 'H'] = "red2"


 pdf("UNOEx2_PCA_ARSyN_HMGB1_RPKM.pdf", width = 5*2, height = 5)
par(mfrow = c(1,1))
# PC1 & PC2
rango = diff(range(pca.results$scores[,1:2]))
plot(pca.results$scores[,1:2], col = "white",
     xlab = paste("PC 1 ", round(pca.results$var.exp[1,1]*100,0), "%", sep = ""),
     ylab = paste("PC 2 ", round(pca.results$var.exp[2,1]*100,0), "%", sep = ""),
     main = "PCA scores",
     xlim = range(pca.results$scores[,1:2]) + 0.02*rango*c(-1,1),
     ylim = range(pca.results$scores[,1:2]) + 0.02*rango*c(-1,1))
points(pca.results$scores[,1], pca.results$scores[,2], col = mycol, cex = 1.5)  
legend("topright", legend=unique(as.character(myfactors$type)), col=unique(mycol), pch=21)


ggplot(data=melt((myARSyN[ ,sample(1:ncol(myARSyN), 6)])),aes(y=value, x=X2, group=X2, colour=X2))+geom_boxplot()

ggplot(data=melt((myARSyN[ ,sample(1:ncol(myARSyN), 6)])),aes(x=value, group=X2, colour=X2))+geom_density()
dev.off()
dim(myARSyN)
#[1] 9461   6

sanos<-myARSyN[,1:3]
sanos<-cbind(gene=row.names(sanos),sanos)
enfermos<-myARSyN[,4:6]
enfermos<-cbind(gene=row.names(enfermos),enfermos)

#### 3) DIFFERENTIAL EXPRESSION
##Haciendo el an??lisis con lima
library("limma")
target<-data.frame(treatment=factor(substr(start=1, stop=1, colnames(myARSyN)), level=c("C", "H")),
                   replicate=colnames(myARSyN))
table(target$treatment)
#   C   H 
#   3   3
dim(myARSyN)
# [1] 9461    6
design<-model.matrix(~1+treatment, data=target)
head(design)
#   (Intercept) treatmentH
# 1           1          0
# 2           1          0
# 3           1          0
# 4           1          1
# 5           1          1
# 6           1          1


fit <- lmFit(myARSyN, design)
head(fit$coefficients)
# (Intercept)   treatmentH
# A4GALT    5.532384  0.022543351
# AAAS      6.522139  0.005237553
# AACS      5.319669 -0.090251814
# AAED1     3.937927  0.098683154
# AAGAB     6.191925 -0.010995173
# AAMP      7.460755 -0.074065599

fit2 <- eBayes(fit)
topTable(fit2, n = 10)
#                 logFC  AveExpr         t      P.Value adj.P.Val         B
# S100A8      1.3200914 4.354539  5.862190 0.0008583906         1 -2.585487
# TYMP        0.4290689 4.761885  5.823501 0.0008903177         1 -2.592674
#######
##The most differentially expressedgene with a relatively good level of confidence 
## is S100A8, which is overexpressed. It is a calcium-binding protein
###############################################

library("NOISeq")
myfactors <- data.frame("type" = substr(colnames(myARSyN), start = 1, stop = 1),
                        "day" = substr(colnames(myARSyN), start = 2, stop = 2)
)
myfactors <- data.frame(myfactors, "cond" = apply(myfactors, 1, paste, collapse = "_"))
idGenes<-row.names(feature)%in%row.names(myARSyN)
mydata<- NOISeq::readData(data=myARSyN, 
                          length = feature[idGenes, c("rownames","length")], 
                          biotype = feature$mybiotypes[idGenes], 
                          chromosome = feature[idGenes, c("Chr", "GeneStart", "GeneEnd")], 
                          factors = myfactors, 
                          gc = feature[idGenes, c("rownames","gc")])

mynoiseqbio <- noiseqbio(mydata, norm = "n", k = 0.5, lc = 0, factor = "type", 
                         conditions = NULL, r = 30, plot = FALSE, filter = 0)

results<-table(mynoiseqbio@results[[1]]$prob>(1-0.05))  
results
#    alpha FALSE TRUE
# 1  0.1    9449  12
# 2  1e-02  9460  1

mynoiseqbio.deg <- degenes(mynoiseqbio, q=1-(5e-2))
# [1] "3 differentially expressed features"

det <- nrow(mynoiseqbio.deg)
##visualizacion
pdf("UNONoiseqbioNormFull_HMGB1_RPKM.pdf", width = 7*3, height = 3*3)
par(mfrow = c(1,2))
DE.plot(mynoiseqbio, q = 1-(5e-2), graphic = "expr", log.scale = FALSE)
DE.plot(mynoiseqbio, q = 1-(5e-2), graphic = "MD", log.scale = FALSE)
dev.off()
# [1] "3 differentially expressed features"
write.csv(mynoiseqbio.deg, file = 'UNOnoiseqbioDEGNormalizadosFull_RPKM.csv')
#               C_mean	H_mean	            theta	          prob	log2FC	        length	GC	Chrom	        GeneStart	GeneEnd
# S100A8	3.6944931091	5.01458452546667	-2.34884358984115	1	-0.440753736170042	1156	54.11	1	            153390032	153391188
# ADAM28	3.4234317755	3.7898657821	-1.38408612435332	0.9502318142639	-0.146703494632309	64978	35.71	8	  24294040	24359018
# S100A9	4.02693917586667	5.28605843683333	-1.38411915856591	0.95023153167882	-0.392508692376553	3173	52.55	1	153357854	153361027

###Hasta aca se realiz?? el an??lisis