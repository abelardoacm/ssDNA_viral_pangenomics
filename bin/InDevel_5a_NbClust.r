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
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
suppressPackageStartupMessages(library("igraph"))
#################################################
# Reading input
setwd("../results/CPFSCC_vectors") #Location of CPFSCC vectors files
#PosArgs <- as.character(commandArgs(trailingOnly = TRUE))
PosArgs <- c("Geminiviridae",2,6)
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
SumDist.df <- cbind(SumDist.df, Pertenencia.df)
colnames(SumDist.df) <- c("SumDist",
                          "MeanDif",
                          "ward.D_method",
                          "ward.D2_method",
                          "single_method",
                          "complete_method",
                          "average_method",
                          "mcquitty_method",
                          "median_method",
                          "centroid_method",
                          "consensus_method")
methd <- c(3:11)
SumDist.df[,methd] <- lapply(SumDist.df[,methd] , factor)
OrderedDist.df <- SumDist.df[order(SumDist.df$MeanDif),] #sort sum of distances
IndexByDistSum <- seq(from = 1, to = ene)
OrderedDist.df$IndexByDistSum <- IndexByDistSum
setwd("..") 
outdir3 <- ("mkdir -p Clustering_graphics") #make clustering graphics outdir
system(outdir3)
setwd("Clustering_graphics")
GraphMethods <- list(OrderedDist.df$ward.D_method, 
                     OrderedDist.df$ward.D2_method, 
                     OrderedDist.df$single_method, 
                     OrderedDist.df$complete_method, 
                     OrderedDist.df$average_method, 
                     OrderedDist.df$mcquitty_method, 
                     OrderedDist.df$median_method, 
                     OrderedDist.df$centroid_method, 
                     OrderedDist.df$consensus_method)
for (i in 1:length(GraphMethods)){
  outfilename <- paste(family, "_", colnames(OrderedDist.df)[2+i],"_distances_pplot.tiff", sep = "")
  legendtitle <- paste(family, paste("(", colnames(OrderedDist.df)[2+i], ")", sep = ""),"ordered distances by cluster")
  tiff(outfilename, units="in", width=7, height=5, res=600)
  print(ggplot(data=OrderedDist.df, aes(IndexByDistSum, MeanDif)) +
          geom_point(aes(colour = GraphMethods[[i]]), size = 2, alpha = 0.2) +
          theme(legend.position="top") +
          labs(color= legendtitle ))
  dev.off()
}
#################################################
#Clusters PCA
res.pca <- prcomp(datos, scale = TRUE) #make PCA
groups <- as.factor(Pertenencia.df$Consenso) #recover clusters
outfile4 <- paste(family,"_PCA_clusters.tiff", sep = "")
#Draw PCA to tiff file
#Clusters PCA
res.pca <- prcomp(datos, scale = TRUE) #make PCA
grupos <- list(as.factor(Pertenencia.df$Partition_wardD.Best.partition),
               as.factor(Pertenencia.df$Partition_wardD2.Best.partition),
               as.factor(Pertenencia.df$Partition_single.Best.partition),
               as.factor(Pertenencia.df$Partition_complete.Best.partition),
               as.factor(Pertenencia.df$Partition_average.Best.partition),
               as.factor(Pertenencia.df$Partition_mcquitty.Best.partition),
               as.factor(Pertenencia.df$Partition_median.Best.partition),
               as.factor(Pertenencia.df$Partition_centroid.Best.partition),
               as.factor(Pertenencia.df$Consenso))
for (i in 1:length(grupos)){
  outfilename <- paste(family, "_", colnames(OrderedDist.df)[2+i],"_PCA_clusters.tiff", sep = "")
  PCA_title <- as.character(paste(family, "PCA", paste("(", colnames(OrderedDist.df)[2+i], ")", sep = "")))
  tiff(outfilename, units="in", width=7, height=5, res=600) #tiff resolution parameters
  current_pca <- fviz_pca_ind(res.pca,
                              col.ind = grupos[[i]], # color by groups
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
                              title = PCA_title)
  print(current_pca)
  dev.off()
}
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
########################################################
#april 28 2021
#Code from now aims to generate a network

########################################################
#Este bloque genera una red, cuyo layout es muy parecido
#a la disposición de los puntos en un PCA.

family_distmx <- as.matrix(diss_matrix)

g <- graph.full(nrow(family_distmx))
V(g)$label <- rownames(family_distmx)
layout <- layout_with_mds(g, dist = as.matrix(family_distmx))
plot(g, layout = layout, vertex.size = 4)

#La disposición es bisimensional, no está mal, pero deben 
#filtrarse los ejes para sólo dibujar los que estén debajo 
#de un umbral de distancia (o arriba de un umbral de similitud)
# Este libro es para echarle un ojo
# https://sites.fas.harvard.edu/~airoldi/pub/books/BookDraft-CsardiNepuszAiroldi2016.pdf

#################################################

### CREO QUE DEBO FILTRAR A QUE LOS NODOS SE DIBUJEN SOLO POR 
### DEBAJO DE UN UMBRAL DE DISTANCIA. EL GRAFICO QUEDA TODO CULERO 
### SI NO SE HACE UN FILTRADO DE LOS EJES.

myAdjacencyMatrix <- as.matrix(family_distmx)
gra  <- graph.adjacency(myAdjacencyMatrix,weighted=TRUE, mode = "undirected")
df <- get.data.frame(gra)

### Los pesos mas bien deberian ser una medida de similitud, cuando lo que tengo 
### son distancias. Debo transformarlas.

E(gra)$weight <- 1 - (E(gra)$weight/max(E(gra)$weight)) #Distance to norm simmilarity

### HACER UNA COPIA DEL GRAFICO, PERO CON NODOS FILTRADOS
graph_copy <- delete.edges(gra, which(E(gra)$weight < 0.97))
V(graph_copy)$label <- ""
plot(graph_copy, vertex.size = 2) #RED BASE SIN ALGORITMO LAYOUT
l <- layout_with_fr(graph_copy, weights = E(graph_copy)$weight)
l <- norm_coords(l, ymin=-1, ymax=1, xmin=-1, xmax=1) # makes graph more compact
tiff("tmp.tiff", units="in", width=15, height=11, res=600)
plot(graph_copy, layout=l, vertex.size = 0.6, edge.width = 0.2)
dev.off()

### CON OTRO METODO DE LAYOUT 
l <- layout_with_kk(graph_copy)
tiff("tmp2.tiff", units="in", width=15, height=11, res=600)
plot(graph_copy, layout=l, vertex.size = 3, edge.width = 0.2)
dev.off()

#ANOTHER METHOD (THE FIRST I WAS TRYING, BUT I THINK HERE ITS WORKING INVERTED)
tiff("tmp3.tiff", units="in", width=15, height=11, res=600)
plot(graph_copy, layout=layout_with_mds, vertex.size = 3, edge.width = 0.2)
dev.off()


