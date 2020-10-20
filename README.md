# **Pangenomic study of ssDNA viruses**

En contraste a los tres dominios de seres vivos: Bacteria, Archaea y Eucarya, los virus son un grupo polifilético. Por la falta de marcadores evolutivos comunes entre todos los virus han surgido clasificaciones artificiales que no están soportadas por árboles evolutivas. Además, los linajes virales presentan una gran cantidad de eventos de transporte horizontal con sus hospederos, portando así múltiples genes de origen celular cuya historia desafía los esquemas evolutivos clásicos con topologías de árbol.

En pocas palabras, el origen, o múltiples orígenes de los virus es un tema abierto, poco concluyente y con incursiones recientes, que requiere cambios en los paradigmas clásicos de la biología evolutiva.

Este repositorio muestra el workflow utilizado para el estudio del origen de los virus de DNA de cadena sencilla, desde una perspectiva integrativa que hace uso de pangenómica para la detección de secuencias con señal filogenética, métodos de inferencia filogenética bajo esquemas de redes y métodos genómicos bayesianos de reconstrucción de estado.

![](ssDNA_workflow.png)


## **data**


##### **Raw Database**

Esta carpeta contiene los archivos de la base de datos global con 1717. 

Las búsquedas en NCBI refseq se realizaron con los booleanos: 
<em>"Family [ORGANISM] AND srcdb_refseq[PROP] NOT wgs[prop] NOT cellular organisms[Organism] NOT AC_000001:AC_999999[pacc]"</em>

Los archivos de esta carpeta son el input para  **1_Protein_count_filtering.sh** y  **2_Segmented_proteomes_concatenation.py**

##### **Filtered Database**

Esta carpeta contiene los genomas restantes del filtro por conteo de proteínas respecto a los organismos modelos, así como la concatenación de genomas segmentados en archivos únicos. Consiste en 1204 genomas de referencia. 

Los archivos de esta carpeta son el input para  **3_Power_spectrum_analysis.mat**. An alignment-free method to compare large genomic datasets based ond cumulative frequency spectrums of DNA strings.

##### **Euclidean Distance Matrices**

Output matrices of eculcidean distances between each and every pair of genomes from the power spectrum analysis. These matrices are the input for the clustering algorithms: **4_Common_statistic_clustering.r** and **5_Network_based_clustering.sh**. Consensus clusters were then obtained by **6_Consensus_clustering.sh**.

##### **Proteomes clusters**

This directory contains the files grouped by folders corresponding to the same consensus clusters. Such clusters are then called to the pangenomic analysis via **get_homologues**. In this particular case the script **7_Get_homologues_routine.sh** contains the actions to call get homologues software and sort the output pangenomic profiles.

##### **Pangenomic profiles**

WIP

##### **Phylogenies**

WIP

## **bin**

This directory contains the aforementioned scripts

  * **1_Protein_count_filtering.sh** Stablishes cutoff values with the distribution of the protein counts by viral family and reference genomes set by the user. 
  * **2_Segmented_proteomes_concatenation.py** Identifies the files corresponding to segmented genomes by making pairwise comparisons bewtween filenames and checking wether its text distance is under the tresshold value set by user (2 for ssDNA files).
  * **3_Power_spectrum_analysis.mat** Perform a cumulative power spectrum analysis to create a 27 dimensions vector for each genome and computes the euclidean pairwise distances.
  * **4_Common_statistic_clustering.r** Uses NbCLust software package in R to compute 16 different and independent indexes of clusters identification. Clsutering profiles are obtained as membership vectors.
  * **5_Network_based_clustering.sh** Calls the SplitsTree5 software from command line to obtain phylogenetic networks using the Neighbor joining algorithm.
  * **6_Consensus_clustering.sh** Identifies the majority consensus clusters from the NbClust clustering and network-based clustering
  * **7_Get_homologues_routine.sh** Invokes the get_homologues software to compute the pangenomic analysis, finally obtaining the homologues pangenomic profiles.

