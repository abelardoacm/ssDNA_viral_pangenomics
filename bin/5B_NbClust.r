#!/usr/bin/env Rscript
library("NbClust")
setwd("../results/Central_moments_and_covariance_vectors_CPFSCC")
#INPUT
family = as.character(commandArgs(trailingOnly = TRUE))
#family = "Geminiviridae"
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
#Define a subset of those indexes indicating a number of clusters equal to mc
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

#Distancias y Outliers
Distancias <- dist(datos, method = "euclidean", diag=TRUE)
Distancias.matrix <- as.matrix(Distancias)
outfile2 <- paste(family,"distance_matrix.csv", sep="_")
write.csv(Pertenencia.df, outfile2, row.names = TRUE)

#UNUSED CODE
ene <- nrow(Distancias.matrix)
SumDist <- (rowSums(Distancias.matrix))
SumDist.df <- as.data.frame(SumDist)
mean_Distance <- (SumDist.df$SumDist)/ene
SumDist.df$MeanDif <- mean_Distance
FivePerc <- ene*0.05
FivePerc <- round(FivePerc)

OrderedDist.df <- SumDist.df[order(SumDist.df$MeanDif),]

plot(OrderedDist.df$MeanDif, type = "l" )
#### Hasta aqui hago la linear plot de toooodas las distancias promedio, la grafica parece senalar que hubiera dos grupos de genomas

library("factoextra")
res.pca <- prcomp(datos, scale = TRUE)
groups <- as.factor(Pertenencia.df$Consenso)
pruebaaa <- fviz_pca_ind(res.pca,
             col.ind = groups, # color by groups
             palette = c("#00AFBB",  "#FC4E07"),
             addEllipses = TRUE,
             legend.title = "Groups",
             label = "none"
)


#### Codigo para hacer lo de las distancias mejor despues

datos2 <- datos
datos2$Pertenencia <- Pertenencia.df$Consenso
Taxids <- rownames(datos)
Taxids <- as.data.frame(Taxids)
rownames(Taxids) <- rownames(datos)
TaxidPertenencia <- Taxids
TaxidPertenencia$Pertenencia <- datos2$Pertenencia



ClustersDataframesNames <- c()
SplitByClusters <- split.data.frame(datos2, datos2$Pertenencia)
for (i in 1:length(SplitByClusters)){
  GroupName <- paste(family, "cluster", i, sep = "_")
  names(SplitByClusters)[i] <- GroupName
  ClustersDataframesNames[i] <- GroupName
}
SplitByClusters <- lapply(SplitByClusters, function(x) { x["Pertenencia"] <- NULL; x })
SplitByClusters
list2env(SplitByClusters,envir=.GlobalEnv)
ClustersDataframesNames

#### Obtener una lista por cada cluster, conteniendo todos los nombres tipo "taxid_xxxxx" 
Taxids <- rownames(datos)
Taxids <- as.data.frame(Taxids)
rownames(Taxids) <- rownames(datos)
TaxidPertenencia <- Taxids
TaxidPertenencia$Pertenencia <- datos2$Pertenencia
TaxidPertenencia

#### Obtener una lista por cada cluster, conteniendo todos los nombres tipo "taxid_xxxxx" 

#THE absolute route way
virus_clust_2 <- TaxidPertenencia[which(TaxidPertenencia$Pertenencia == 2),1]
virus_clust_1 <- TaxidPertenencia[which(TaxidPertenencia$Pertenencia == 1),1]


#The flexible way
#ClustersTaxidListsNames contains the names of list entries in virus_clust_members_taxids to iterate over
ClustersTaxidListsNames <- c()
virus_clust_members_taxids <- vector(mode = "list", length = nc)
for (i in 1:length(ClustersDataframesNames)){
  virus_clust_members_taxids[[i]] <- TaxidPertenencia[which(TaxidPertenencia$Pertenencia == i),1]
}
for (i in 1:length(virus_clust_members_taxids)){
  GroupName <- paste(family, "cluster", i, "taxids", sep = "_")
  names(virus_clust_members_taxids)[i] <- GroupName
  ClustersTaxidListsNames[i] <- GroupName
}
virus_clust_members_taxids
ClustersTaxidListsNames

### Ahora por cada lista de taxids en virus_clust_members_taxids, debo cortar la matriz Distancias.matrix o el data frame Distancias.matrix.df

list2env(virus_clust_members_taxids,envir=.GlobalEnv)

virus_clust_1y2 <- TaxidPertenencia[which(TaxidPertenencia$Pertenencia == c(2), arr.ind = TRUE),1]



x <- as.dist(Distancias.matrix)
library("usedist")
z <- dist_subset(x, virus_clust_1)

#### Tambien esta la opcion de hacer otro script que despues del clustering haga todo este pedo. Seria mas facil porque no hay que generar otra matriz, simplemente que el script lo haga para un solo grupo, pero que se llame envuelto en otro script que lo haga para todos los clusters

