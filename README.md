# Bugs and Drugs

This pipeline builds on a previous NCBI hacakthon product, [Nastybugs](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance), which is a simple method for extracting antimicrobial res
istance information from metagenomes
Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: 1 approved with reservations]. F1000Research 201
7, 6:1971
(doi: 10.12688/f1000research.12781.1)

## Introduction

The resistome describes all antimicrobial resistance genes, including those found in pathogenic and non-pathogenic bacteria (Wright, G., et al.). While the antibiotic resistome is intrinsic to nearly all environments, particular interest has emerged in the context of human health and the treatment of diseases. Widespread use of antibiotics had led to the emergence of antimicrobial resistance in several strains of pathogenic bacteria. Although mechanisms for antibiotic resistance, such as those to counteract penicillin, likely existed long before the first synthetic antibiotic, cycles of new drug development and the evolutionary response from bacteria, as well as misuse of these antibiotics, have driven the fixation of genes conveying drug resistance (Waglechner, N., et al.; Barbosa, T., et al.). As a result, pressure has mounted to innovate new antimicrobial treatments against multi-drug resistant pathogens in the face of a potentially deadly public health crisis.

High throughput sequencing has allowed researchers to catalogue large databanks of bacterial sequences, and the ability to examine the genetic code of the pathogenic microbes has given insight into some of the genes that confer antibiotic resistance. Accurate tools predicting specific antibiotic resistance in a microbial sample may allow physicians to give more precise and effective treatments for infections, leading to better patient outcomes and reducing the rate of antimicrobial resistance. While progress has already been made within the private sector towards consolidating multiple antibiotic resistance databases, analyzing and visualizing the resulting data, there are still very few free and publicly accessible pipelines serving this purpose. 
Here, we present Bugs and Drugs (B.A.D.), an open-source pipeline to analyze microbial samples for potentially antibiotic-resistant phenotypes and present pertinent results in a series of dynamic visualizations. 

*If nanopore sequencing added to pipeline:////move to next steps if not

![workflow](https://github.com/stevetsa/Versa_AB_Resist/blob/master/workflow.png "Workflow")

## Implementation

As seen in Figure 1 (work flow diagram), we have leveraged several open source tools to enable to deploy a single solution to process their fastq files.  We have improved upon Nasty Bugs (Tsang, H.  et al., 2017) in several ways by using the new RGI tool (Jia et al, 2017) to predict antibiotic resistance through comparison with the CARD,  expanding inputs used by the programm, connecting annotations about the resistomes found, and adding an interactive visualization.

We assembled several resources for filtering out host reads, classifying resistant species, and visualizing relative abundance of the metagenomic classification within your samples. We have also included annotations from CARD that provide additional information on the mechanisms of resistance to specific drugs in order to inform the precision and efficacy of treatment decisions. We have also integrated KEGG resistome data into the visualization in tabular format to show how SNPs affect response to certain drugs, which may also be useful in studying how domain structures allow bacteria to elude antibiotics. In addition, we also display the relative counts per gene and taxa within an interactive dashboard run from a container. Users have the option to run an instance of the application locally or from a Cloud instance via Docker. As such, this program can generate interactive visualizations and associate ontologies and classifications without having to visit several websites.  
