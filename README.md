# **ssDNA viral pangenomics**

in brief...

**Viruses are a polyphyletic group**. Due to the lack of common evolutionary markers among all viruses, artificial classifications not supported by evolutionary trees, have arisen. Furthermore, viral lineages present a large number of horizontal transport events with their hosts, thus carrying multiple genes of cellular origin **defying classical evolutionary schemes**.

The origin, or multiple origins of viruses **is an inconclusive research topic that requires shifts in the classic paradigms and recent evolutive analysis tools**.

This repository shows the workflow used to study the **origin of single-stranded DNA viruses from an integrative perspective** that makes use of **pangenomics** for the detection of relevant clusters for the group origins, **alignment free methods for whole-genome comparisons**, and phylogenetic inference methods compatible with **network evolutionary schemes**, allowing the incorporation of cellular protein sequences to perform remote homologues searches.

>## **Cloning this repo**

ssDNA\_viral\_pangenomics is a repository that depends on other github repositories. To avoid not allowed re-distribution of used files from those repositories, we included a [.gitmodules file](https://git-scm.com/book/en/v2/Git-Tools-Submodules). Because of that, you should clone this repo as follows.

``` 
git clone https://github.com/abelardoacm/ssDNA_viral_pangenomics.git
cd ssDNA_viral_pangenomics/
git submodule init
git submodule update
cd bin/FSWM/
make
```
>## **Dependencies**
These are ssDNA_viral_pangenomics external dependencies, links to their installing instructions, commands for installation, and used versions:
 
 | Software name (version used) 	| Terminal 	| Installation *debian based dist. 	|
|-	|-	|-	|
| [EMBOSS](http://emboss.sourceforge.net/download/) (6.5.7) 	| bash 	| `sudo apt-get install emboss` 	|
| [Biopython](https://biopython.org/wiki/Download) (1.78) 	| bash 	| `sudo apt-get install python3-biopython` 	|
| [Numpy](https://numpy.org/install/) (1.19.4) 	| bash 	| `sudo apt-get install python3-numpy` 	|
| [MATLAB](https://la.mathworks.com/products/matlab.html) (R2020b)<br>+ bioinformatics toolbox 	| bash 	| `online installation via installation script` 	|
| [NbClust](https://cran.r-project.org/web/packages/NbClust/index.html) (3.0) 	| R (4.0.3) 	| `install.packages("NbClust")` 	|
| [factoextra](https://rpkgs.datanovia.com/factoextra/index.html) (1.0.7) 	| R (4.0.3) 	| `install.packages("factoextra")` 	|
| [tidyverse](https://www.tidyverse.org/) (1.3.0) 	| R (4.0.3) 	| `install.packages("tidyverse")` 	|
| [Corbi](https://cran.r-project.org/web/packages/Corbi/index.html) (0.6-1) 	| R (4.0.3) 	| `install.packages("Corbi")` 	|
| [xts](https://cran.r-project.org/web/packages/xts/xts.pdf) (0.12.1) 	| R (4.0.3) 	| `install.packages("xts")` 	|

>## **Repo tree**

These are the key repository folders :

``` 
├── bin
│   ├── FSWM
│   └── The-central-moments-and-covariance-vector-of-cumulative-Fourier-Transform-power-and-phase-spectra
├── data
│   ├── AF_methods_input
│   ├── Genomic_fasta_files
│   │   ├── _fasta_genomes
│   │   ├── Geminiviridae_catfiltered_fasta_genomes
│   │   ├── Geminiviridae_concatenated_fasta_genomes
│   │   └── Geminiviridae_fasta_genomes
│   ├── Individual_full_genbank_files
│   │   ├── Geminiviridae_catfiltered_genbank_genomes
│   │   ├── Geminiviridae_concatenated_genbank_genomes
│   │   └── Geminiviridae_genbank_genomes
│   ├── Proteomic_fasta_files
│   │   ├── _fasta_proteomes
│   │   ├── Geminiviridae_catfiltered_fasta_proteomes
│   │   ├── Geminiviridae_concatenated_fasta_proteomes
│   │   └── Geminiviridae_fasta_proteomes
│   └── Raw_database
└── results
    ├── Central_moments_and_covariance_vectors_CPFSCC
    ├── Clans
    ├── Clustering_graphics
    ├── Distance_Matrices
    ├── Lists_for_sample_reduction
    ├── NbClust_membership_vectors
    └── Pangenomic_input_clusters
        └── Geminiviridae_clusters
            ├── cluster_1
            └── cluster_2
```
_NOTE\* for storage purposes only files corresponding to Geminiviridae family are available. Whole raw database will be available before research results submission_

# Repo navigation guide

<p align="center">
  <img width="755" height="1132" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/ssDNA_workflow.png">
</p>

## From raw to filtered database

### **Expected Raw_database**

This folder should contain direct downloads from NCBI refseq. Viral sequences can be searched family by family with the following general query:

``` 
Family [ORGANISM] AND srcdb_refseq[PROP] NOT wgs[prop] NOT cellular organisms[Organism] NOT AC_000001:AC_999999[pacc]
```

Results from queries are downloaded in Genbank(full) format with illustrated parameters. 

<p align="center">
  <img width="285" height="377" src="https://raw.githubusercontent.com/abelardoacm/ssDNA_viral_pangenomics/main/query_download_parameters.png">
</p>

The download default name for genomes genbank concatenation is **sequences.gb**, which we suggest to change into **family.gb** (i.e. Geminiviridae.gb).

### **Obtaining Genomic_fasta_files/ Individual_full_genbank_files/ and Proteomic_fasta_files/**

These folders are needed to begin data processing once the **family.gb** file is deposited in the Raw_database directory. Three format transformations are required, these are:

  * **[Genomic fasta](data/Genomic_fasta_files)**. Nucleotide fasta files for each viral species. An example of this file is _Tomato-mild-mosaic-virus-DNA-B-complete-genome\_NC\_010834\_taxid\_536086\_.fn_
   
``` 
>Tomato-mild-mosaic-virus-DNA-B-complete-genome|NC_010834|taxid_536086|
accggatgcccgcgcgattttttccccccctacgtggcgctctggaggtcgttcgatccg
atcgaacgtgtccccactggtgttctctctcccctggtgtccgttggatttcctctacgc
caaatcagttgagcgcgtttttgacgtccgccaaatgagttcagcgcattttttgagttc
cgcctattggatgctgacacgtcgcatcctatctatgtagacgcgcgctcaactgttaga
tattgtcagttcgcgatatcagctgtagaccgttggataaatctgacatgcaatccagct
ggattgtatattggaacttgaattatttgggcgcgactgacagaagacggccccattgta
and so on...
```
  * **[Proteomic fasta](data/Proteomic_fasta_files)**. Amino acids files containing the fasta protein sequences of each viral species. An example of this file is _Tomato-mild-mosaic-virus-DNA-B-complete-genome\_NC\_010834\_taxid\_536086\_.faa_
  
``` 
>YP_001960950.1 | GeneID:6395843 |  | locus-TMMVsB_gp1 | nuclear shuttle protein
MYPVKYRRGWSTTQRRSYRRAPVFKRNAVKRADWIRRPSNSMKA
HDEPKMTAQRIHENQFGPEFMMVQNTAISTYISFPNLGKTEPNRSRSYIKLKRLRFKG
TVKIERVQPDVNMDGSVSKTEGVFSLVVVVDRKPHLGPSGCLHTFDELFGARIHSHGN
LSITPSLKDRYYIRHVTKHVLSAEKDTMMVNLEGTTFLSNRRVSCWAGFKDHDHDSCN
GVYANISKNALLVYYCWMSDIMSKASTFVSYDLDYVG
>YP_001960951.1 | GeneID:6395842 |  | locus-TMMVsB_gp2 | movement protein
MESQLANPPNAFNYIESQRDEYQLSHDLTEIVLQFPSTASQISA
RLSRRCMKIDHCVIEYRQQVPINATGAVVVEIHDKRMTDNESLQASWTFPIRCNIDLH
YFSSSFFSLKDPIPWKLYYRVCDTNVHQRTHFAKFKGKLKLSTAKHSVDIPFRAPTVK
ILSKQFTDKDVDFCHVGYGRWERKPVRSASASTIGLRSPIQLRPGESWAVRSTVGANP
SDAESDIVETSHPYRELNRLGTTMLDPGESASIVGAQRAQSNITMSLGQLNELLRNTV
QECINSNCVPSQAKSLN
    and so on...
```
  * **[Individual genbank files](data/Individual_full_genbank_files)**. These are the most inclusive files for individual species, as they contain protein sequences of amino acids and whole genome sequence, as well as many more lines of information. This type of files will be processed and filtered to serve as input for **get_homologues** pangenomic analysis. An example of this file is _Tomato-mild-mosaic-virus-DNA-B-complete-genome\_NC\_010834\_taxid\_536086\_.gbk_

```   
LOCUS       NC_010834               2663 bp    DNA     circular VRL 14-AUG-2018
DEFINITION  Tomato mild mosaic virus DNA-B, complete genome.
ACCESSION   NC_010834
KEYWORDS    RefSeq.
SOURCE      Tomato mild mosaic virus
  ORGANISM  Tomato mild mosaic virus
REFERENCE   2  (bases 1 to 2663)
REFERENCE   3  (bases 1 to 2663)
COMMENT     PROVISIONAL REFSEQ: This record has not yet been subject to final
            NCBI review. The reference sequence was derived from EU710753.
            COMPLETENESS: full length.
FEATURES             Location/Qualifiers
     source          1..2663
                     /organism="Tomato mild mosaic virus"
    and so on...
```
  
To obtain each format file for every species, the **family.gb** file must be splitted into individual species files. This is performed by [1_Set_family_files_from_raw_genbank.sh](bin/1_Set_family_files_from_raw_genbank.sh), and is executed from command line, indcating the family name as argument. For example:

``` 
./1_Set_family_files_from_raw_genbank.sh Geminiviridae
```
The bash script executes [Genbank_to_genomic_fasta_taxid_in_name.pl](bin/Genbank_to_genomic_fasta_taxid_in_name.pl), [Genbank_to_proteomic_fasta_taxid_in_name.pl](bin/Genbank_to_proteomic_fasta_taxid_in_name.pl) and [Print_rename_instructions.pl](bin/Print_rename_instructions.pl). Each of them generate the files and sub-folders mentioned above departing from **family.gb** file.

Once the script finishes, a small report is displayed in the terminal. This is what you see when you run [1_Set_family_files_from_raw_genbank.sh](bin/1_Set_family_files_from_raw_genbank.sh) for the Geminiviridae family.

``` 
The file Geminiviridae.gb was splitted into 704 individual genomic(.fn), proteomic(.faa) and full-genbank(.gbk) files

 
Messages similar to "Warning: bad /collection_date value" point out that the date in the file is not in the correct format.
Such cases can be corrected although it is not needed to continue.


Read sequences and write them to individual files
Warning: bad /collection_date value '2015-09-02'
Warning: NC_031466: Bad value '2015-09-02' for tag '/collection_date'
Warning: bad /collection_date value '2014-10-01'
Warning: NC_039003: Bad value '2014-10-01' for tag '/collection_date'
```

### **\*\_concatenated\_\* folders**

As a result of the previous step, three folders are generated. These however, do not always correspond to complete genomes. Some viral families with segmented genomes are present and represent a potencial source of pangenomic core underestimation. A previously opened issue can be visited [here](https://github.com/abelardoacm/ssDNA_viral_pangenomics/issues/2) for further details. Those viral families led us to devise a strategy to concatenate the separate files of a viral species.

The [2_Concatenation_from_taxid.pl](bin/2_Concatenation_from_taxid.pl) script fulfills the task of comparing files and concatenates those that share the same taxonomic id and source organism. It is used from command line as follows (for Geminiviridae family):

``` 
perl 2_Concatenation_from_taxid.pl Geminiviridae
```
An output message summarizes how many files were concatenated and how many segments make them up. For example:

``` 
Geminiviridae.gb generated 704 individual files
After concatenation the number of files reduced to 538

... as the following report indicates


      4  segments were concatenated into Rhynchosia-golden-mosaic-virus_taxid_117198 
      2  segments were concatenated into Wissadula-golden-mosaic-virus_taxid_51673
and so on...

```
The concatenated files are moved to the corresponding folders within their file types, labeled with the word **concatenated** in the name. For example: [Geminiviridae_concatenated_fasta_genomes](data/Genomic_fasta_files/Geminiviridae_concatenated_fasta_genomes), [Geminiviridae_concatenated_fasta_proteomes](data/Genomic_fasta_files/Geminiviridae_concatenated_fasta_proteomes), and [Geminiviridae_concatenated_genbank_genomes](data/Genomic_fasta_files/Geminiviridae_concatenated_genbank_genomes). 

### **\*\_catfiltered\_\* folders**

Another potential source of pangenomic misestimation comes from two sources:

- **Zero protein count files**. Some files within the samples can be blank. This error comes from the NCBI submission itself. The search performed with aforementioned booleans sometimes yields entries labeled as "PROVISIONAL REFSEQ", files containing unannotated genomes. The software for pangenomic analysis would decrease protein prevalence, leading to core underestimation.

- **Over concatenated files**. As a product of [2_Concatenation_from_taxid.pl](bin/2_Concatenation_from_taxid.pl) script, non related segments can be put together. This happens when there is no distinction between source organism names and there's more than one reference genome in **Refseq** for the same taxid.

The [3_Protein_count_filtering.pl](bin/3_Protein_count_filtering.pl) script fulfills the task of filtering files whose protein counts varies in more than a user-defined limit percentage (2nd positional argument). To prevent the exclusion of reference strains with uncommon protein count, the script can make cutoff values less extreme, indicating values corresponding to the minimum (3rd positional argument) and maximum (4th positional argument) protein count within reference strains.

It can be used from command line as the following example for Geminiviridae family:

``` 
perl 3_Protein_count_filtering.pl Geminiviridae 85 3 12
```
... where Geminiviridae is the viral family, 85 is the percentage of allowed variation from the mean, 3 is the minimum protein count for a reference strain, and 12 the maximum.

An output message summarizes cutoff values and filtered files. For example:

``` 
mean protein count is 7 (rounded-up) 

... setting lower protein cutoff count in 2 proteins 
... setting upper protein cutoff count in 13 proteins 

African-cassava-mosaic-virus_taxid_10817 will be filtered as protein count is 0 
Rhynchosia-golden-mosaic-virus_taxid_117198 will be filtered as protein count is 14 
Tomato-golden-leaf-distortion-virus_taxid_858511 will be filtered as protein count is 0 
Tomato-golden-leaf-spot-virus_taxid_1336597 will be filtered as protein count is 0 

4 organisms were discarded from the database for further analysis
```
## From filtered database to distance matrices

This step in our workflow is by far the more customizable. Up to this point you generated files almost ready to serve as input for pangenomic analysis, however an additional step is suggested. Given the scale of analysis, we recommend the generation of sub-clusters within each family, once again in order to prevent pangenomic core underestimation. For that purpose we need to generate pairwise distance matrices.

This project is not focused on proteomic taxonomic classification, so among sequence comparison methods we prefer fast alignment free methods. Two algorithms will be used: 

- [**Cummulative Power Spectrum**](http://www.sciencedirect.com/science/article/pii/S2001037019301965) (Pei _et al_. 2019)
- [**Filtered Spaced-Word Matches**](https://academic.oup.com/bioinformatics/article/33/7/971/2883388) (Leimester _et al_. 2017)

### **results\/Central_moments_and_covariance_vectors_CPFSCC\/**

This folder contains the output of [4\_Vectors\_CPFSCC.sh](bin/4_Vectors_CPFSCC.sh), an enveope of [CPFSCC.m](https://github.com/YaulabTsinghua/The-central-moments-and-covariance-vector-of-cumulative-Fourier-Transform-power-and-phase-spectra/blob/399d912e958a5074db8476a9b24236692e3ddd09/CPFSCC.m). It is used from command line as follows:

``` 
./4_Vectors_CPFSCC.sh Geminiviridae
```
It will generate the central moments and covariance vectors of cumulative Fourier Transform power and phase spectra of Geminiviridae genomes. Output family\_CPFSCC\_vectors.txt containing all 28-dimension vectors of the family genomes is automatically deposited into [results\/Central\_moments\_and\_covariance\_vectors\_CPFSCC\/](results/Central_moments_and_covariance_vectors_CPFSCC/). Aditionally, the final input for matlab script can be viewed in [data/AF\_methods\_input/](data/AF_methods_input).

### **results/Distance_Matrices**

As stated by the authors of the cumulative Fourier Transform power and phase spectra method (Pei _et al_. 2019), the usual step following vectors computation is the estimation of pairwise distances, commonly euclidean distances.

Euclidean distance matrices are implemented at this point in ourk workflow, however they are saved to an output by a script until the following step. If you wish to obtain the distance matrix of a family, from the [output](results/Central_moments_and_covariance_vectors_CPFSCC/) of [4\_Vectors\_CPFSCC.sh](bin/4_Vectors_CPFSCC.sh), the following lines of R code can be executed:

```
#input (cpfscc vectors of a family)
cpfscc.df <- as.data.frame(t(as.matrix(read.csv(family_CPFSCC_file, header = TRUE, sep = ",", dec = "."))))
#output (euclidean distances computation)
dis_matrix<- dist(cpfscc.df, method = "euclidean", diag=FALSE)
```
...where dis_matrix is the "dis" class object containing the euclidean distance matrix.

## From distance matrices to pangenomic inputs clusters
### **Genomes clusters**

To perform sequence clustering from euclidean distances, we used the R package ["NbClust"](https://cran.r-project.org/web/packages/NbClust/index.html), the script [5_NbClust.r](bin/5_NbClust.r) makes use of NbClust to calculate 13 indexes. Each index propose an optimal number of clusters, and the most common value is then used to compute memberships vectors with 8 different methods ("wardD", "wardD2", "single", "complete", "average", "mcquitty", "median" and "centroid". See [notes on the method argument](https://www.rdocumentation.org/packages/NbClust/versions/3.0/topics/NbClust)). Finally a "Consensus" vector is generated, containing the most popular assignation for each viral genome file.

[5_NbClust.r](bin/5_NbClust.r) is used from command line as follows (example for Geminiviridae family):
```
Rscript 5_NbClust.r Geminiviridae 1 10
```
... where 1 and 10 define the limits of the number of clusters to explore

The outputs for this script are:
- [**family_distances_pplot.tiff**](results/Clustering_graphics). A linear point plot of the genomes colored by cluster and sorted in ascending order according to their total average value of paired distances (_y_ axis). Located in [results/Clustering_graphics](results/Clustering_graphics).
- [**family_PCA_clusters.tiff**](results/Clustering_graphics). A PCA plot of the genomes of the family colored by cluster and ellipses of 95% of the concentration ellipse in normal probability.Located in [results/Clustering_graphics](results/Clustering_graphics)
- [**family_distance_matrix.csv**](results/Distance_Matrices). csv file containing the paired euclidean distance matrix of members within a family. Located in [results/Distance_Matrices](results/Distance_Matrices)
- [**Geminiviridae_membership_vectors.csv**](results/NbClust_membership_vectors). csv file containing the membership vectors from the different partition methods implemented by NbClust. Located in [results/NbClust_membership_vectors](results/NbClust_membership_vectors)

### **Sample reduction by distances**

Based on linear point and PCA plots of a family, you can choose whether or not to perform a sample reduction based on the distances, and an arbitrary cutoff percentage.

The script [**5b_Sample_reduction.r**](bin/5b_Sample_reduction.r) fulfills this task, and can be used from bash terminal as follows:
```
Rscript 5b_Sample_reduction.r Geminiviridae 10
```
...where 10 is the arbitrary cutoff percentage. This means that within each cluster, the genomes corresponding to the most distant ten percent will be discarded for pangenomic analysis. The identifiers of these genomes are stored in a list titled **xx_percent_most_distant_family.txt** in [results/Lists_for_sample_reduction](results/Lists_for_sample_reduction).

A second version of PCA and distances point plots will be saved along with the previous ones, labeled as **"after_sr_by_xx_percent"**. 


### **Relocation of files in assigned clusters**

With the consensus membership vectors ready, each file can be relocated to its cluster. This task is fulfilled by the script [6_Files_to_clusters.sh](bin/6_Files_to_clusters.sh). For example:

```
./6_Files_to_clusters.sh Geminiviridae
```
...this command creates one folder for each Geminiviridae cluster found by NbClust (2 in this case), copies files to its corresponding folder and moves the output  
to [/results/Pangenomic_input_clusters/](/results/Pangenomic_input_clusters/).

## From pangenomic inputs clusters to pangenomic profiles

WIP

## From pangenomic profiles to phylogenies
### **Phylogenies**

WIP







