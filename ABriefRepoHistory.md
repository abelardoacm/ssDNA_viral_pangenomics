# A Brief RepoHistory :closed_book:

#### These are the conclusions, objectives achieved and the tragic history of ssDNA_viral_pangenomics
#### ...like goodol stories it is a trilogy :rocket::rocket::rocket:

## In the shadows :skull:

The date is September 2020. This is the subfolder tree of my shameful folder titled **"ProyectoMaestría2"**. Don't bother to analyze it, the structure lacks logic and order, while it is littered with poorly nested folders and *"tmp", "tmp2"* or *"deleteMe"* files.

```
ProyectoMaestría2
.
├── GB2fastasplitnoLTR
│   └── Sample306_Fixed_All
├── Literatura
│   ├── Antecedentes LabOrigen
│   ├── Redes
│   └── Virología
├── NUEVAS_MATRICES
├── PowerSpectrum
│   └── MatricesListasParaSplitsTree
│       └── MatricesParaNbClust
├── Python_scripts_concatenate
├── Resultados
├── Secuencias
│   ├── Alphasatellitidae
│   │   ├── FastaGenomes
│   │   └── Genomas.gb_Alphasatellitidae
│   ├── Anelloviridae
│   │   ├── FastaGenomes
│   │   └── Genomas.gb_Anelloviridae
│   ├── Bacilladnaviridae
│   │   ├── FastaGenomes
│   │   └── Genomas.gb_Bacilladnaviridae
│   │       └── PangenomaTutoral1
│   │           ├── PangenomaCluster1
│   │           ├── PangenomaCluster1_homologues
│   │           │   └── tmp
│   │           ├── PangenomaCluster2
│   │           ├── PangenomaCompleto
│   │           ├── PangenomaCompleto_homologues
│   │           │   ├── Chaetocerosprotobacilladnavirus3DNAcompletegenome_f0_0taxa_algCOG_e0_
│   │           │   ├── Chaetocerosprotobacilladnavirus3DNAcompletegenome_f0_0taxa_algOMCL_e0_
│   │           │   ├── Chaetocerosprotobacilladnavirus3DNAcompletegenome_f0_alltaxa_algBDBH_e0_
│   │           │   └── tmp
│   │           └── sample_intersection
└── UNIFICACION
```
As I anticipated, if folders are scary, **files are horrifying**. The scripts that I had implemented up to that moment required to be totally changed to operate with different data, because in some cases the data itself was part of the script. Given one step, it was impossible to go back. Consequently, only some of my 15 ssDNA viral families were selected to generate figures to present to my committee.

The need to start over was imminent and a trace of it is the "UNIFICACION" folder...

## A cage :egg: that actually releases :hatching_chick: : bin, data results :hatched_chick: 

The day I met github in the **bioinformatics workshop** I knew that everything that lived in *"ProyectoMaestriaBueno"* had to fit into three folders titled **bin, data and results**. At first I thought of them as cages to contain my uncontrollable but useless scripts. Paradoxically they could only enter their cages by acquiring freedom . I remember that the moment I heard from Alicia *"... everything should be able to run from bin"*  I thought, ooooohhhh so you also think the same, but it'ss kinda impossible right?

Fortunately **it is not**, and that same day I started giving wings to my little demons :bird: . For those in process, I created container files with specific locations and the challenge was to get them to work from there [bin](bin/), read from [data](data/) and send everything to [results/](results). My **ssDNA_viral_pangenomics** repository was born and it was great to have reliable and automatic change control for the first time.

## Fast and furious :police_car: :red_car: :police_car:

In the first six months of my project, I made advances only for a single family (Bacilladnaviridae). All the time I knew it was wrong but I needed results.

**The date is someday in January 2021**, after editing my scripts numbered 1-6, I just uploaded my last commit for pre-managing data for my pangenomic analysis. The [0.1_Master_Driver.sh](bin/0.1_Master_Driver.sh) script is the first code file that I would feel good about sharing. My work can be summarized as:

1. Download genomes
2. Filter database
3. Cluster by distances

A few months ago I presented the results for a viral family up to step 3. Today, after downloading the raw data, **it takes no more than a couple of minutes** to generate the 3 steps for a family, with [textual](results/Master_reports/) and [graphic reports](results/Clustering_graphics/). This is my work operating on all the genomes available for the Monodnaviria taxon (all single-stranded DNA viruses):

![](Monodnaviria.gif)

Although the approach of generating paired distances without alignments is not my own, I am happy to be able to couple the analysis to raw data, external clustering software, generate clustering graphs and a written report.


# Analyzes and discussion :chart_with_downwards_trend:
## So what's in the repo right now?
I'll show some results to guide you trough. However, it has to be mainly restricted to data manipulation since merely biological interpretation will arise later after computing phylogenies and remote homologs search. 

Consider the following steps from [0.1_Master_Driver.sh](bin/0.1_Master_Driver.sh):

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/Steps.png)

### From raw to filtered database

The first three steps of my workflow fulfill the task of, [separating a raw file with 1_Set_family_files_from_raw_genbank.sh](bin/1_Set_family_files_from_raw_genbank.sh) into individual per species files, then [2_Concatenation_from_taxid.pl](bin/2_Concatenation_from_taxid.pl) concatenates segments files belonging to the same genome and then [filtering outliers](bin/3_Protein_count_filtering.pl) based on the count of proteins. Everything starting from a single family.gb file.

The first two steps operate without parameters, yielding always the same result for a given input. Their reports include only the number of operated files. Since not all families have segmented genomes, it was also a challenge to give the option to skip this step in the workflow.

These are the key report lines for **Monodnaviria**:

for the first step the number of processed files...

```
------------1_Set_family_files_from_raw_genbank.sh------------


The file Monodnaviria.gb was splitted into 1785 individual genomic(.fn), proteomic(.faa) and full-genbank(.gbk) files
```
... and for the second the effect of concatenating segments
```
------------2_Concatenation_from_taxid.pl------------


Monodnaviria.gb generated 1785 individual files
After concatenation the number of files reduced to 1526

... as the following report indicates


      9  segments were concatenated into Gammapapillomavirus-sp_taxid_2049444 
```
The only remaining script bellonging to this section is [3_Protein_count_filtering.pl](bin/3_Protein_count_filtering.pl). It's objective (also the main goal of pre data managing) is to prevent pangenomic core underestimation by the inclusion of outliers. It needs some parameters, so it does not always yield the same outcome. I had the self proclaimed great idea of **including a table in stdout** that summarizes the **what if...?** for the possible allowed variations, it will surely help to decide the cutoff percentage allowing to consider the number of remaining files on each scenario. 

This is the **what if table** for Monodnaviria:

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/whatif.png)

Deleted files and cutoff values are also printed to master report, that's soooo convenient to go back and check.

```
------------3_Protein_count_filtering.pl------------
Allowed percentage of variation from average protein count: 50
No minimum protein count from reference proteome was given... setting lower limit to -%50 deviation from the mean 

No maximum protein count from reference proteome was given... setting upper limit to +%50 deviation from the mean 


mean protein count is 6 (rounded-up) 

... setting lower protein cutoff count in 3 proteins 
... setting upper protein cutoff count in 9 proteins 

_____________________________________
 The following files will be filtered:

	Protein count	Species + Taxonimic ID

	   2   	 Acartia-tonsa-copepod-circovirus_taxid_1168547
```
### From filtered db to distance matrices :triangular_ruler:

Paired distances are pure gold for evolutionary analyzes. There are lots of phylogeny inference methods that rely on paired distances. **So... we need a multiple aligment right?**. Guess what.. :no_entry_sign: **NOOOOO** :no_entry_sign:, they are great but you can't always use them, with **Monodnaviria genomes** that'd never end. Remember, this repo is fast and furious, we'll try to keep a huge database while possible, and I'll mkae my best to make it possible.

I implemented a [very interesting AF-method that relies in Fast Fourier Transforms (Dong, et al. 2018)](https://www.sciencedirect.com/science/article/abs/pii/S037811191830698X), to estimate a 28 dimensional vector that corresponds 1 to 1 to a genome. **That's an incredible property!!!**, because different to multiple aligments (that correspond many vs many), incorporating a new genome, **means to add one line and column to the paired distance matrix**, not a complete re estimation of paired distances. There's no clear reason to show you a distance matrix but here's one anyway.

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/DistMx.png)

**Oh oh, libre office calc has no support for a million cells !!!** Of course this is far from being a Big Data thing, but it's also far from being displayed in GUI software. And thats one of my points, it's easy to pick 10 genomes and perform a pangenomic analysis, but we (the origin of life lab) **aim to operate over thousands**, **ranging over every viral family**. I don't really want to take a deotur but this fact strongly supports collaborative coding, I want my solution to be the solution for upcoming students in the lab.

### From distance matrices to pangenomics input clusters

For the grand finale I want to show a clustering scheme [(5a_NbClust.r)](bin/5a_NbClust.r) for Monodnaviria, which reported:
```
------------5a_NbClust.r Monodnaviria  ------------

Minimum number of clusters allowed: 1
Maximum number of clusters allowed: 15

Number of clusters found for Monodnaviria genomes: 3
```
The package NbClust (which I've to admit to don't fully understand), estimates 6 different indices and 6 possible scenarios for clustering an input. I coupled the Af-output to be this input, and also programmed a consensus function in R that recover the most popular purpose. This PCA shows the most popular purposes for clustering Monodnaviria, it was automatically performed with [5a_NbClust.r](bin/5a_NbClust.r):

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/mono.png)

And I'm very proud to say that clusters are congruent with major ssDNA groups, although I'd not use it as a pangenomic input for my purposes since I've to be more precise in searching the genomic traces of the origin of the families. 

Finally I got my files, safe and sound in folders ready to serve as pangenomic input clusters. To demonstrate it, these are the pangenomic clusters of **Nanoviridae** whcich is my favorite example since there are about 15 reference **but segmented genomes**. This made that refseq raw files were useless as pangenomic inputs, and my work had a key role:

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/rocaleta.png)

The graph above shows the distribution of ortholog clusters. We use pangenomic analysis to know where to take a closer look, and wee need to zoom in the pangenomic core shared genes with evolutionary analysis. As I anticipated the main goal of filtering data is to prevent core underestimation (which result in non existant core). Here's a graph that shows how the number of clusters found within the core decrease as we increase the sample size, it was also performed in R but the script is still not a part of the repo:

![](https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/corepangenomics.png)

As you can see, **pangenomic core exist**, at the least there's evidence to look for remote homologs and trace the origin of this family !!!, probably to celullar escaped proteins... but that's the second trilogy of my research

## Conclusions

The impact of taking my analysis to a structure that favors reproducibility is huge. The fact that my work can be shared is good not only for other members of my laboratory (who should adopt these practices too), but also for me. I can interrupt my work and a future myself will not have so much trouble to resume. My project is now even portable, I can wokr from other sites and move forward with much more fluidity. For my next results report to my committee, it will not only be some lucky families that make it to the latest analysis, today it may be 15 ssDNAs or more. The implemented graphs surely will be part of my results to report and they are already much better than the ones I did previously almost by hand. I found the ggplot package quite attractive and useful to implement and I generate cool graphs.

My goals now will be to optimize the code so that it operates faster, as well as to implement alternatives to the matlab script (which thanks to the [solved issue](https://github.com/abelardoacm/ssDNA_viral_pangenomics/issues) is about to be incorporated).I'm excited about the direction the project has taken once it has the flexibility that living on github gives. It will also be interesting to contrast different alignment-free methods that can be implemented, and even later generate benchmarks of the methods based on their performance to classify viral sequences prior to a pangenomic analysis whose purpose is the classification of orthologs of interest. to address the origins and early evolution of viral groups.

