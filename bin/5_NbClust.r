#!/usr/bin/env Rscript
library("NbClust")
setwd("../results/Central_moments_and_covariance_vectors_CPFSCC")
#INPUT
family = as.character(commandArgs(trailingOnly = TRUE))
file_suffix <- ("CPFSCC_vectors.txt")
family_CPFSCC_file <- paste(family,file_suffix, sep = "_")
tmp <- as.matrix(read.csv(family_CPFSCC_file, header = TRUE, sep = ",", dec = "."))
tmp2 <- t(tmp)
colnames(tmp2) <- c('D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','D12','D13','D14','D15','D16','D17','D18','D19','D20','D21','D22','D23','D24','D25','D26','D27','D28')
datos <- as.data.frame(tmp2)
#NbClust index estimation
indexes <- c("kl","ch", "hartigan", "cindex", "db", "silhouette", "ratkowsky", "ball", "ptbiserial", "mcclain", "dunn", "sdindex", "sdbw")
Best_num_clust <- c()
diss_matrix<- dist(datos, method = "euclidean", diag=FALSE)
#Up to this point, data is ready to be used.
#Following block can be changed by a for loop instead, with iterations through object indexes
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "kl")
Best_num_clust["kl"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "ch")
Best_num_clust["ch"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "hartigan")
Best_num_clust["hartigan"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "cindex")
Best_num_clust["cindex"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "db")
Best_num_clust["db"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "silhouette")
Best_num_clust["silhouette"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "ratkowsky")
Best_num_clust["ratkowsky"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "ball")
Best_num_clust["ball"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "ptbiserial")
Best_num_clust["ptbiserial"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "mcclain")
Best_num_clust["mcclain"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "dunn")
Best_num_clust["dunn"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "sdindex")
Best_num_clust["sdindex"] <- res$Best.nc[1]
res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = "sdbw")
Best_num_clust["sdbw"] <- res$Best.nc[1]
#Turn Best number of clusters to dataframe
Bestnc <- as.data.frame(Best_num_clust)
#Saving the most observed number of cluster into "nc" object
names(sort(summary(as.factor(Bestnc$Best_num_clust)), decreasing = TRUE)[1])
nc <- names(sort(summary(as.factor(Bestnc$Best_num_clust)), decreasing = TRUE)[1])
#Define a subser of those indexes indicating a number of clusters equal to mc
ncsubset <- subset(Bestnc, Best_num_clust==nc)
#Selecting index to operate partitions
first_index <- rownames(ncsubset)[1]
#Computing partitions, these lines could be substitutted to a for loop
Partition_wardD <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D", index = first_index)
Partition_wardD2 <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "ward.D2", index = first_index)
Partition_single <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "single", index = first_index)
Partition_complete <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "complete", index = first_index)
Partition_average <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "average", index = first_index)
Partition_mcquitty <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "mcquitty", index = first_index)
Partition_median <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "median", index = first_index)
Partition_centroid <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=1, max.nc=6, method = "centroid", index = first_index)
#Recovering row names
taxids <- rownames(datos)
Pertenencia.df <- data.frame(Partition_wardD$Best.partition, Partition_wardD2$Best.partition, Partition_single$Best.partition, Partition_complete$Best.partition, Partition_average$Best.partition, Partition_mcquitty$Best.partition, Partition_median$Best.partition, Partition_centroid$Best.partition)
function.moda<-function(n)
{
  names(sort(summary(as.factor(n)), decreasing = TRUE)[1]) 
}
Pertenencia.df$Consenso <- apply(Pertenencia.df, 1, function.moda)
#OUTPUT
setwd("..")
outdir <- ("mkdir NbClust_membership_vectors")
system(outdir)
setwd("NbClust_membership_vectors")
outfile <- paste(family,"membership_vectors.csv", sep="_")
write.csv(Pertenencia.df, outfile, row.names = TRUE)
