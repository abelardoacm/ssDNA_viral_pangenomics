# **ssDNA viral pangenomics**

in brief...

**Viruses are a polyphyletic group**. Due to the lack of common evolutionary markers among all viruses, artificial classifications not supported by evolutionary trees, have arisen. Furthermore, viral lineages present a large number of horizontal transport events with their hosts, thus carrying multiple genes of cellular origin **defying classical evolutionary schemes**.

The origin, or multiple origins of viruses **is an inconclusive research topic that requires shifts in the classic paradigms and recent evolutive analysis tools**.

This repository shows the workflow used to study the **origin of single-stranded DNA viruses from an integrative perspective** that makes use of **pangenomics** for the detection of relevant clusters for the group origins, **alignment free methods for whole-genome comparisons**, and phylogenetic inference methods compatible with **network evolutionary schemes**, allowing the incorporation of cellular protein sequences to perform remote homologues searches.

<p align="center">
  <img width="755" height="1132" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/ssDNA_workflow.png">
</p>

>## **Cloning this repo**

ssDNA\_viral\_pangenomics is a repository that depends on other github repositories. To avoid not allowed re-distribution of used files from those repositories, we included a .gitmodules file. Because of that, you should clone this repo as follows.

``` 
git clone https://github.com/abelardoacm/ssDNA_viral_pangenomics.git
cd ssDNA_viral_pangenomics/
git submodule init
git submodule update 
```
Here's what you will find inside [bin](bin/) and [data](data/)
**NOTE: for storage purposes only files corresponding to Geminiviridae family are available. Whole raw database will be available before research results submission**

>## **data/**



#### **Raw_database**

This folder should contain direct downloads from NCBI refseq. Sequences are searched family by family with the following general query:

``` 
Family [ORGANISM] AND srcdb_refseq[PROP] NOT wgs[prop] NOT cellular organisms[Organism] NOT AC_000001:AC_999999[pacc]
```

Results from queries were downloaded in Genbank(full) format with illustrated parameters. 

<p align="center">
  <img width="285" height="377" src="https://raw.githubusercontent.com/abelardoacm/ssDNA_viral_pangenomics/main/query_download_parameters.png">
</p>

The download default name for genomes genbank concatenation is **sequences.gb**, which must be changed into **family.gb** (i.e. Geminiviridae.gb).

#### **Genomic_fasta_files Individual_full_genbank_files and Proteomic_fasta_files**

These folders are needed to begin data processing once the **family.gb** file is deposited in the Raw_database directory. If the repo is not cloned, then user must create them in the right location. For example, from repo main folder:

``` 
cd data/
mkdir Genomic_fasta_files data Individual_full_genbank_files Proteomic_fasta_files
```

Three formats are required, each one corresponds to the folders just mentioned, these are:

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
                     /mol_type="genomic DNA"
                     /isolate="BR:Pda58:05"
                     /host="tomato"
                     /db_xref="taxon:536086"
                     /segment="DNA B"
                     /country="Brazil"
                     /collection_date="May-2005"
     gene            518..1285
                     /gene="NSP"
                     /locus_tag="TMMVsB_gp1"
                     /db_xref="GeneID:6395843"
     CDS             518..1285
                     /gene="NSP"
                     /locus_tag="TMMVsB_gp1"
                     /codon_start=1
                     /product="nuclear shuttle protein"
                     /protein_id="YP_001960950.1"
                     /db_xref="GeneID:6395843"
                     /translation="MYPVKYRRGWSTTQRRSYRRAPVFKRNAVKRADWIRRPSNSMKA
                     HDEPKMTAQRIHENQFGPEFMMVQNTAISTYISFPNLGKTEPNRSRSYIKLKRLRFKG
                     TVKIERVQPDVNMDGSVSKTEGVFSLVVVVDRKPHLGPSGCLHTFDELFGARIHSHGN
                     LSITPSLKDRYYIRHVTKHVLSAEKDTMMVNLEGTTFLSNRRVSCWAGFKDHDHDSCN
                     GVYANISKNALLVYYCWMSDIMSKASTFVSYDLDYVG"
    
    and so on...
```
  
To obtain each format file for every species, the **family.gb** file must be splitted into individual species files. This is performed by [1_Set_family_files_from_raw_genbank.sh](bin/1_Set_family_files_from_raw_genbank.sh), and is executed from command line, indcating the family name as argument. For example:

``` 
./1_Set_family_files_from_raw_genbank.sh Geminiviridae
```
The bash script execute the perl scripts: [Genbank_to_genomic_fasta_taxid_in_name.pl](bin/Genbank_to_genomic_fasta_taxid_in_name.pl), [Genbank_to_proteomic_fasta_taxid_in_name.pl](bin/Genbank_to_proteomic_fasta_taxid_in_name.pl) and [Print_rename_instructions.pl](bin/Print_rename_instructions.pl). Each of them generate the files and sub-folders mentioned above departing from **family.gb** file.

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

#### **\*\_concatenated\_\* folders**

As a result of the previous step, three folders are generated. These however, do not always correspond to complete genomes. Some viral families have segmented genomes are present in and represent a potencial source of pangenomic core underestimation. A previously opened issue can be visited [here](https://github.com/abelardoacm/ssDNA_viral_pangenomics/issues/2) for further details. Those viral families led us to devise a strategy to concatenate the separate files of a viral species.

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

#### **\*\_catfiltered\_\* folders**

Another potential source of pangenomic misestimation comes from two sources:

- Zero protein count files. Some files within the samples can be blank. This error comes from the NCBI submission itself. The search performed with aforementioned booleans sometimes yields entries labeled as "PROVISIONAL REFSEQ", files containing unannotated genomes. The software for pangenomic analysis would decrease protein prevalence, leading to core underestimation.

- Over concatenated files. As a product of [2_Concatenation_from_taxid.pl](bin/2_Concatenation_from_taxid.pl) script, non related segments can be put together. This happens when there is no distinction between source organism names and there's more than one reference genome in **Refseq** for the same taxid.

The [3_Protein_count_filtering.pl](bin/3_Protein_count_filtering.pl) script fulfills the task of filtering files whose protein counts varies in more than a user-defined limit percentage (2nd positional argument). To prevent the exclusion of reference strains with uncommon protein count, the script can make cutoff values ​​less extreme, indicating values corresponding to the minimum (3rd positional argument) and maximum (4th positional argument) protein count within reference strains.

It can used from command line as the following example for Geminiviridae family:

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



#### **Distance Matrices**

This step in our workflow is by far the more customizable. Up to this point you generated files almost ready to serve as input for pangenomic analysis, however an additional step is suggested. Given the scale of analysis, we recommend the generation of sub-clusters within each family, once again in order to prevent pangenomic core underestimation. For that purpose we need to generate pairwise distance matrices.

This projects is not focused on proteomic taxonomic classification, so among sequence comparison methods we prefer fast alignment free methods. Two algorithms will be used: 

- [**Cummulative Power Spectrum**](http://www.sciencedirect.com/science/article/pii/S2001037019301965) (Pei _et al_. 2019)
- [**Filtered Spaced-Word Matches**](https://academic.oup.com/bioinformatics/article/33/7/971/2883388) (Leimester _et al_)


#### **Proteomes clusters**

WIP

#### **Pangenomic profiles**

WIP


#### **Phylogenies**

WIP



>## **bin/**

This directory contains the aforementioned scripts




