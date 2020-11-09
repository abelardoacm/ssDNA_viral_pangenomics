# **ssDNA viral pangenomics**

in brief...

**Viruses are a polyphyletic group**. Due to the lack of common evolutionary markers among all viruses, artificial classifications not supported by evolutionary trees, have arisen. Furthermore, viral lineages present a large number of horizontal transport events with their hosts, thus carrying multiple genes of cellular origin **defying classical evolutionary schemes**.

The origin, or multiple origins of viruses **is an inconclusive research topic that requires shifts in the classic paradigms and recent evolutive analysis tools**.

This repository shows the workflow used to study the **origin of single-stranded DNA viruses from an integrative perspective** that makes use of **pangenomics** for the detection of relevant clusters for the group origins, **alignment free methods for whole-genome comparisons**, and phylogenetic inference methods compatible with **network evolutionary schemes**, allowing the incorporation of cellular protein sequences to perform remote homologues searches.

<p align="center">
  <img width="755" height="1132" src="https://github.com/abelardoacm/ssDNA_viral_pangenomics/blob/main/ssDNA_workflow.png">
</p>

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

These folders are needed to begin data processing once the **family.gb** file is deposited in the Raw_database directory. If the repo is not cloned, then user must create them in the right location. For example, from main folder:

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
The bash script execute three perl scripts [Genbank_to_genomic_fasta_taxid_in_name.pl](bin/Genbank_to_genomic_fasta_taxid_in_name.pl), [Genbank_to_proteomic_fasta_taxid_in_name.pl](bin/Genbank_to_proteomic_fasta_taxid_in_name.pl) and [Print_rename_instructions.pl](bin/Print_rename_instructions.pl). Each of them generate the files and sub-folders mentioned above departing from **family.gb** file.
Note: Some files within Proteoimic_fasta_files are blank. This error does not come from the script, but from the NCBI submission itself. The search performed with aforementioned booleans sometimes yields entries labeled as "PROVISIONAL REFSEQ", files containing reference but unannotated genomes.

#### **Filtered Database**

WIP


#### **Euclidean Distance Matrices**

WIP

#### **Proteomes clusters**

WIP

#### **Pangenomic profiles**

WIP


#### **Phylogenies**

WIP



>## **bin/**

This directory contains the aforementioned scripts




