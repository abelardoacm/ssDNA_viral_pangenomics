#!/usr/bin/env Rscript

#Objective: The task for Sample_reduction.r is to print a list of the "n" percent most distant taxids within clusters of a family
#It's used as a subroutine of a bash script

# This script should be called from bin/
# Inputs for this script are ../results/Distance_Matrices/$family_distance_matrix.csv and ../NbClust_membership_vectors/$family__membership_vectors.csv

# Suggested minimum of 20 genomes.

#Needed libraries
suppressPackageStartupMessages(library("Corbi"))
suppressPackageStartupMessages(library("xts"))
suppressPackageStartupMessages(library("NbClust"))
suppressPackageStartupMessages(library("factoextra"))
suppressPackageStartupMessages(library("stringr"))
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("ggplot2"))

#INPUT 1
#Collecting first input ../results/Distance_Matrices/$family_distance_matrix.csv to environment
setwd("../results/Distance_Matrices/") #Location of .csv distance matrices
PosArgs <- as.character(commandArgs(trailingOnly = TRUE)) #Reading positional argument 
family <- PosArgs[1] #Create "family" object (e.g. family = "Geminiviridae")
file_suffix <- ("distance_matrix.csv") #Building input filename
family_distmx <- paste(family,file_suffix, sep = "_") #Building input filename
family_distmx <- read.csv(family_distmx, header = TRUE, sep = ",", dec = ".") #Reading .csv input file
#Transform to data frame and name rows by taxids
family_distmx <- as.data.frame(family_distmx)
OriginalTaxids <- family_distmx$X
family_distmx$X <- NULL
row.names(family_distmx) <- OriginalTaxids

#INPUT 2
#Collecting second input ../results/Distance_Matrices/$family_membership_vectors.csv to environment
setwd("../NbClust_membership_vectors") #Location of membership vectors
file_suffix2 <- ("_membership_vectors.csv") #Building input filename to read it
family_membership <- paste(family,file_suffix2, sep = "") #Building input filename to read it
family_membership <- read.csv(family_membership, header = TRUE, sep = ",", dec = ".") #Reading .csv input file
#Transform to data frame and name rows by taxids
family_membership <- as.data.frame(family_membership)
TaxidPertenencia <- data.frame(OriginalTaxids, family_membership$Consenso, row.names = OriginalTaxids)
colnames(TaxidPertenencia)<- c("Taxids","Pertenencia") #Data frame summarizing which taxids are members of each cluster
setwd("../Distance_Matrices/") #Return to ../Distance_Matrices/

#OUTPUT
outfile <- paste(PosArgs[2], "_percent_most_distant_", family,".txt", sep = "") #Naming outfile
outdir <- ("mkdir -p ../Lists_for_sample_reduction/") #Naming outdir
system(outdir) #Make outdir

#Computations
ClustersTaxidListsNames <- c() #Empty vector to name clusters
clusters <- unique(TaxidPertenencia$Pertenencia) #Identifying clusters
nc <- max(unique(TaxidPertenencia$Pertenencia)) #Save number of clusters
virus_clust_members_taxids <- vector(mode = "list", length = nc) #Empty vector list to contain all taxids of each cluster
index_by_cluster <- c() #Empty vector list to contain virus's global indexes of each cluster
  #Assigning taxids and indexes in nested lists
for (i in clusters){ #Iterate as many loops as clusters
  virus_clust_members_taxids[[i]] <- TaxidPertenencia[which(TaxidPertenencia$Pertenencia == i),1] #Assign taxids of each cluster
  index_by_cluster[[i]] <- which(TaxidPertenencia$Pertenencia == i) #Assign virus's global indexes of each cluster
}
  #Renaming nested lists with cluster names
for (i in 1:length(virus_clust_members_taxids)){
  GroupName <- paste(family, "cluster", i, "taxids", sep = "_")
  names(virus_clust_members_taxids)[i] <- GroupName
  names(index_by_cluster)[i] <- GroupName
  ClustersTaxidListsNames[i] <- GroupName
}
  #Generating sub-matrices of pairwise distance corresponding to each cluster
SubMatrices <- c() #Empty vector to serve as nested list
matrix2subset <- as.matrix(family_distmx) #Re-saving object to prevent miss-manipulations
    #Saving sub-matrices
for (i in 1:length(index_by_cluster)){
  SubMatrices[[i]] <- submatrix(matrix2subset, (index_by_cluster[[i]]), (index_by_cluster[[i]])) #Use submatrix {Corbi} function
}
  #Estimating pairwise distance sum for each genome within SubMatrices
ListOfDistSums <- c()
for (i in 1:length(clusters)){
  ListOfDistSums[[i]] <- colSums(SubMatrices[[i]])
}
  #Sort decreasing values of pairwise distances sum
SortedListOfDistSums <- c()
for (i in 1:length(clusters)){
  SortedListOfDistSums[[i]] <- sort(colSums(SubMatrices[[i]]), decreasing = TRUE)
}
  #Compute the number of genomes that correspond to the "n" percent of each cluster
Perc = (as.numeric(PosArgs[2]))/100 #Read and set desired percentage of reduction
PercByClust <- c()
for (i in 1:length(clusters)){
  PercByClust[[i]] <- round((length(ListOfDistSums[[i]]))*Perc) #Getting the "n" percent
}
  #Obtain the "n" percent biggest values
MostDist <- c()
for (i in 1:length(clusters)){
  MostDist[[i]] <- first(SortedListOfDistSums[[i]], PercByClust[[i]]) #Use first {xts} function
}
# Set outdir to save output
setwd("../Lists_for_sample_reduction/")
  #Retrieve taxids to delete by searching with virus's local index
IndexesToDelete <- c()
sink(outfile) #Print taxids to delete as .txt list
for (i in 1:length(MostDist)){
  for (e in MostDist[[i]]){
    IndexesToDelete <- which(ListOfDistSums[[i]] == e)
    cat(virus_clust_members_taxids[[i]][IndexesToDelete], "in", family, "cluster_", i, "\n")
  }
}
sink()



#Re making graphics of 5_NbClust.r to visualize clustering effects
RecoverOutput <- scan(outfile, what="", sep="\n") #Read the output list of taxids to delete
TaxDel <- c() #List containing taxids to delete
for (i in 1:length(RecoverOutput)){
  TaxDel[i] <- word(RecoverOutput[i], 1)
}
  #Use TaxDel to repeat code for 5_NbClust.r figures  , deleting what's inside TaxDel
    
    #Rebuilding data object
setwd("../CPFSCC_vectors/") #Location of CPFSCC vectors files
file_suffix3 <- ("CPFSCC_vectors.txt") #Suffix to build input filename
family_CPFSCC_file <- paste(family,file_suffix3, sep = "_") #Read filename
CPFSCC <- as.matrix(read.csv(family_CPFSCC_file, header = TRUE, sep = ",", dec = ".")) #Transform to matrix
TransposeCPFSCC <- t(CPFSCC) #Transpose matrix
colnames(TransposeCPFSCC) <- sprintf("D%d", 1:28) #Name columns dimensions
CPFSCC.df <- as.data.frame(TransposeCPFSCC) # Object datos is the final input for the upcoming computations
setwd("../Clustering_graphics/") #Going to second output folder
   
    #Subset deleting with TaxDel
TaxDelSubset <- rownames_to_column(CPFSCC.df)
TaxDelSubset$Membership <- TaxidPertenencia$Pertenencia
TaxDelSubset <- TaxDelSubset[!(TaxDelSubset$rowname %in% TaxDel), ]
groups <- as.factor(TaxDelSubset$Membership) #recover clusters
row.names(TaxDelSubset) <- TaxDelSubset$rowname
TaxDelSubset$rowname <- NULL
TaxDelSubset$Membership <- NULL

    #Clusters PCA
res.pca <- prcomp(TaxDelSubset, scale = TRUE) #make PCA
      #Draw PCA and ellipses
setwd("../Clustering_graphics")
outfile4 <- paste(family,"_PCA_clusters_after_sr_by_", PosArgs[2], "_percent.tiff", sep = "") #sr stands for "sample reduction"
tiff(outfile4, units="in", width=7, height=5, res=600) 
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
             title = paste(family, "clusters after sample reduction")
)
dev.off()

   #Linear plot
Distances <- dist(TaxDelSubset, method = "euclidean", diag=TRUE) #Estimate pairwise distances
Distances.matrix <- as.matrix(Distances) #Transform to matrix
n <- nrow(Distances.matrix) #number of genomes
SumDistAfter <- (rowSums(Distances.matrix)) #get sum of distances by genome
SumDistAfter.df <- as.data.frame(SumDistAfter) #transform to data frame
mean_Distance <- (SumDistAfter.df$SumDist)/n #get average sum of distances per genome
SumDistAfter.df$MeanDif <- mean_Distance #save average sum to data frame
Ids <- rownames(Distances.matrix)
SumDistAfter.df$Membership <- as.factor(groups)
OrderedDistAfter.df <- SumDistAfter.df[order(SumDistAfter.df$MeanDif),] #sort sum of distances
IndexByDistSum <- seq(from = 1, to = n)
OrderedDistAfter.df$IndexByDistSum <- IndexByDistSum
outfile3 <- paste(family,"_distances_pplot_after_sr_by_", PosArgs[2], "_percent.tiff", sep = "") #name third outfile
legendtitle <- paste(family, "ordered distances by cluster after sr")
tiff(outfile3, units="in", width=7, height=5, res=600) #assign third output
ggplot(data=OrderedDistAfter.df, aes(IndexByDistSum, MeanDif)) +
  geom_point(aes(colour = Membership), size = 2, alpha = 0.2) +
  theme(legend.position="top") +
  labs(color= legendtitle )
dev.off()

#Delete xx percent from membership vectors csv
setwd("../../bin/")
DelCommand = paste("./Sample_reduction.sh",family)
system(DelCommand)












