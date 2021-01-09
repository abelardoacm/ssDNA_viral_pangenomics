#!/usr/bin/env Rscript
#5a_NbClust.r
#
#Author: Abelardo Aguilar Camara
#
#Task performed:
#    This script takes the CPFSCC 28 dimensional vectors of a family, 
#    performs 13 different clustering indices, and returns a family 
#    membership data frame with consensus clustering
#
#
#NOTE:"CPFSCC" stands for central moments and covariance vectors of cumulative fourier transform power and phase spectra
#
#INPUT: CPFSCC vectors of anytaxon from  ../results/CPFSCC_vectors/anytaxon_CPFSCC_vectors.txt
#
#OUTPUT: Membership vectors        in    ../results/NbClust_membership_vectors/
#        Distance matrix           in    ../results/Distance_Matrices/
#        Point plot of distances   in    ../results/Clustering_graphics
#        Clusters PCA              in    ../results/Clustering_graphics
#
#################################################
#
#5a_NbClust.r
#
#################################################
# Load needed packages
suppressPackageStartupMessages(library("NbClust"))
suppressPackageStartupMessages(library("factoextra"))
suppressPackageStartupMessages(library("ggplot2"))
#################################################
# Reading input
setwd("../results/CPFSCC_vectors") #Location of CPFSCC vectors files
PosArgs <- as.character(commandArgs(trailingOnly = TRUE))
family = PosArgs[1]  #Reads positional arguments to define family (e.g. family = "Geminiviridae")
mincluster = as.numeric(PosArgs[2]) # defines minimum number of clusters
maxcluster = as.numeric(PosArgs[3]) # defines maximum number of clusters
file_suffix <- ("CPFSCC_vectors.txt") #Suffix to build input filename
family_CPFSCC_file <- paste(family,file_suffix, sep = "_") #Read filename
tmp <- as.matrix(read.csv(family_CPFSCC_file, header = TRUE, sep = ",", dec = ".")) #Transform to matrix
tmp2 <- t(tmp)
colnames(tmp2) <- sprintf("D%d", 1:28) #Name columns dimensions
datos <- as.data.frame(tmp2) # Object datos is the final input for the upcoming computations
#################################################
#indices to estimate
indexes <- c("kl",
             "ch", 
             "hartigan", 
             "cindex", 
             "db", 
             "silhouette", 
             "ratkowsky", 
             "ball", 
             "ptbiserial", 
             "mcclain", 
             "dunn", 
             "sdindex", 
             "sdbw") 
diss_matrix<- dist(datos, method = "euclidean", diag=FALSE) #Pairwise distance matrix
#################################################
#Estimating the best number of clusters
res <- c() # Vector to contain results
Best_num_clust <- c() #Vector to contain best number of cluster proposed by each index
#Loop over indices to compute
for (i in indexes){
  res <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D", index = i)
  Best_num_clust[i] <- res$Best.nc[1]
}
Bestnc <- as.data.frame(Best_num_clust) #to dataframe
nc <- names(sort(summary(as.factor(Bestnc$Best_num_clust)), decreasing = TRUE)[1]) #Saves the most observed number of clusters
ncsubset <- subset(Bestnc, Best_num_clust==nc) #Defines a subset of those indexes indicating matching nc
first_index <- rownames(ncsubset)[1] #Selects index to operate partitions
#################################################
#Computing partitions
#Can be changed to for loop but I prefer this way to easily find when a partition method aborts
Partition_wardD <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D", index = first_index)
Partition_wardD2 <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "ward.D2", index = first_index)
Partition_single <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "single", index = first_index)
Partition_complete <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "complete", index = first_index)
Partition_average <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "average", index = first_index)
Partition_mcquitty <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "mcquitty", index = first_index)
Partition_median <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "median", index = first_index)
Partition_centroid <- NbClust(datos, diss=diss_matrix, distance = NULL, min.nc=mincluster, max.nc=maxcluster, method = "centroid", index = first_index)
#Save partitions to data frame
taxids <- rownames(datos)
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
#Distance matrix
outdir2 <- ("mkdir -p ../Distance_Matrices/") 
system(outdir2) #Make distance matrices outdir
setwd("../Distance_Matrices/")
Distancias <- dist(datos, method = "euclidean", diag=TRUE) #Estimate pairwise distances
Distancias.matrix <- as.matrix(Distancias) #Transform to matrix
outfile2 <- paste(family,"distance_matrix.csv", sep="_")
write.csv(Distancias.matrix, outfile2, row.names = TRUE) #Write distance matrix as csv
#################################################
#Point plot of ordered distances (pplot)
ene <- nrow(Distancias.matrix) #number of genomes
SumDist <- (rowSums(Distancias.matrix)) #get sum of distances by genome
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



