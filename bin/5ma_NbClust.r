#!/usr/bin/env Rscript
#5ma_NbClust.r
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script reads the mash distance matrix of a family, 
#    performs different clustering indices and returns a family 
#    membership data frame with consensus clustering
#
#
#INPUT: mash_distmx of anytaxon from  ..results/Distance_Matrices
#
#OUTPUT: Membership vectors        in    ../results/NbClust_membership_vectors/
#        Point plot of distances   in    ../results/Clustering_graphics
#        Clusters PCA              in    ../results/Clustering_graphics
#
#################################################
#
#5ma_NbClust.r
#
#################################################
# Load needed packages
suppressPackageStartupMessages(library("NbClust"))
suppressPackageStartupMessages(library("factoextra"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
#################################################
# Reading input
setwd("../results/Distance_Matrices") # mashdistmx location
PosArgs <- as.character(commandArgs(trailingOnly = TRUE))
family = "Circoviridae"
family = PosArgs[1]  #Reads positional arguments to define family (e.g. family = "Geminiviridae")
mincluster = as.numeric(PosArgs[2]) # defines minimum number of clusters
maxcluster = as.numeric(PosArgs[3]) # defines maximum number of clusters
file_suffix <- ("mash_distmx.csv") #Suffix to build input filename
distmx_filename <- paste(family,file_suffix, sep = "_") #Read filename
family_distmx <- as.matrix(read.csv(distmx_filename, header = TRUE, sep = ",", dec = ".")) #Transform to matrix
family_distmx<- as.data.frame(family_distmx)
rownames(family_distmx) <- family_distmx$X
family_distmx$X <- NULL
dist <- as.dist(family_distmx)
#################################################
#indices to estimate
indexes <- c("cindex", 
             "silhouette", 
             "mcclain", 
             "dunn") 
#################################################
#Estimating the best number of clusters
res <- c() # Vector to contain results
Best_num_clust <- c() #Vector to contain best number of cluster proposed by each index
#Loop over indices to compute
for (i in indexes){
  res <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D", index = i)
  Best_num_clust[i] <- res$Best.nc[1]
}
Bestnc <- as.data.frame(Best_num_clust) #to dataframe
nc <- names(sort(summary(as.factor(Bestnc$Best_num_clust)), decreasing = TRUE)[1]) #Saves the most observed number of clusters
ncsubset <- subset(Bestnc, Best_num_clust==nc) #Defines a subset of those indexes indicating matching nc
first_index <- rownames(ncsubset)[1] #Selects index to operate partitions
#################################################
#Computing partitions
#Can be changed to for loop but I prefer this way to easily find when a partition method aborts
Partition_wardD <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D", index = first_index)
Partition_wardD2 <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D2", index = first_index)
Partition_single <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "single", index = first_index)
Partition_complete <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "complete", index = first_index)
Partition_average <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "average", index = first_index)
Partition_mcquitty <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "mcquitty", index = first_index)
Partition_median <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "median", index = first_index)
Partition_centroid <- NbClust(diss=dist, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "centroid", index = first_index)
#Save partitions to data frame
taxids <- rownames(family_distmx)
Pertenencia.df <- data.frame(Partition_wardD$Best.partition, 
                             Partition_wardD2$Best.partition, 
                             Partition_single$Best.partition, 
                             Partition_complete$Best.partition, 
                             Partition_average$Best.partition, 
                             Partition_mcquitty$Best.partition, 
                             Partition_median$Best.partition, 
                             Partition_centroid$Best.partition)
#################################################
#Define a function "moda" to recover the most popular clusters membership proposition for each genome
function.moda<-function(n)
{
  names(sort(summary(as.factor(n)), decreasing = TRUE)[1]) 
}
#################################################
#Use function.moda to estimate consensus membership vector
Pertenencia.df$Consenso <- apply(Pertenencia.df, 1, function.moda)
#################################################
#################################################
#Save outputs
#Membership vectors
setwd("..")
outdir <- ("mkdir -p NbClust_membership_vectors") #Make membership vectors outdir
system(outdir) #Make outdir
setwd("NbClust_membership_vectors")
outfile <- paste(family,"membership_vectors.csv", sep="_")
write.csv(Pertenencia.df, outfile, row.names = TRUE) #Write membership vectors file
#################################################
#Point plot of ordered distances (pplot)
numericdist <- as.data.frame(lapply(family_distmx,as.numeric))
ene <- nrow(numericdist) #number of genomes
SumDist <- (rowSums(numericdist)) #get sum of distances by genome
SumDist.df <- as.data.frame(SumDist) #transform to data frame
mean_Distance <- (SumDist.df$SumDist)/ene #get average sum of distances per genome
SumDist.df$MeanDif <- mean_Distance #save average sum to data frame
SumDist.df$Membership <- as.factor(Pertenencia.df$Consenso)
OrderedDist.df <- SumDist.df[order(SumDist.df$MeanDif),] #sort sum of distances
IndexByDistSum <- seq(from = 1, to = ene)
OrderedDist.df$IndexByDistSum <- IndexByDistSum
outfile3 <- paste(family,"_distances_pplot.tiff", sep = "") #name pplot outfile
setwd("..") 
outdir3 <- ("mkdir -p Clustering_graphics") #make clustering graphics outdir
system(outdir3)
legendtitle <- paste(family, "ordered distances by cluster")
setwd("Clustering_graphics")
# ggplot pplot in tiff file
tiff(outfile3, units="in", width=7, height=5, res=600) #tiff resolution parameters
ggplot(data=OrderedDist.df, aes(IndexByDistSum, MeanDif)) +
  geom_point(aes(colour = Membership), size = 2, alpha = 0.2) +
  theme(legend.position="top") +
  labs(color= legendtitle )
dev.off()
#################################################
#Clusters PCA
##### CHECAR LA PAGINA QUE DEJO ABIERTA DE INTERNET PARA HACER UN PCA LIKE SOLO CON LAS DISTANCIAS


res.pca <- prcomp(datos, scale = TRUE) #make PCA
groups <- as.factor(Pertenencia.df$Consenso) #recover clusters
outfile4 <- paste(family,"_PCA_clusters.tiff", sep = "")
#Draw PCA to tiff file
tiff(outfile4, units="in", width=7, height=5, res=600) #tiff resolution parameters
fviz_pca_ind(res.pca,
             col.ind = groups, # color by groups
             palette = c("#00AFBB", 
                         "#FC4E07", 
                         "#50f0d0", 
                         "#f05070", 
                         "#d050f0", 
                         "#70f050", 
                         "#f0d050", 
                         "#ffd88d", 
                         "#5086a7", 
                         "#dd9082", 
                         "#093d3a", 
                         "#196f69", 
                         "#786045", 
                         "#d59c2c", 
                         "#336936", 
                         "#d050f0", 
                         "#70f050", 
                         "#f0d050", 
                         "#50f0d0", 
                         "#f05070"),
             addEllipses = TRUE,
             ellipse.level=0.95,
             legend.title = "cluster",
             label = "none",
             title = paste(family, "clusters")
)
dev.off()