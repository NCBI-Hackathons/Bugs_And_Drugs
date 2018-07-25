# Bugs and Drugs (B.A.D.)
![logo](https://github.com/NCBI-Hackathons/Bugs_And_Drugs/blob/master/BAD%20logo%20text.jpg "logo")

*This pipeline builds upon [Nastybugs](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance), a program developed in a previous NCBI hackathon designed to extract antimicrobial resistance information from metagenomes.*

## Introduction

The resistome describes all antimicrobial resistance genes, including those found in pathogenic and non-pathogenic bacteria (Wright, G., et al.). While the antibiotic resistome is intrinsic to nearly all environments, particular interest has emerged in the context of human health and the treatment of diseases. Widespread use of antibiotics had led to the emergence of antimicrobial resistance in several strains of pathogenic bacteria. As a result, pressure has mounted to innovate new antimicrobial treatments against multi-drug resistant pathogens in the face of a potentially deadly public health crisis. Accurate tools predicting specific antibiotic resistance in a microbial sample may allow physicians to give more precise and effective treatments for infections, leading to better patient outcomes and reducing the rate of antimicrobial resistance. While progress has already been made within the private sector towards consolidating multiple antibiotic resistance databases, analyzing and visualizing the resulting data, there are still very few free and publicly accessible pipelines serving this purpose. Here, we present **Bugs and Drugs (B.A.D.)**, an open-source pipeline to analyze microbial samples for potentially antibiotic-resistant phenotypes and present pertinent results in a series of dynamic visualizations. 

## Software Dependencies
This program can be used as a standalone in a Jupyter notebook or run in a Docker container. Please ensure that Python version 3.5 or greater with Jupyter module  _**or**_ Docker is installed on your machine.
Google Cloud Platform VM (VM type, Ubuntu 14.04) is used for the example below.   

## Installation
### Jupyter Notebooks
```
apt-get install -y python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install jupyter 
```
### Docker
1. First, [install Docker](https://docs.docker.com/install/) if it is not already on your machine. On the Docker website, refer to the menu on the side to find the correct ope
rating system and corresponding installation guide.
2. Enter the following from the command line to run the docker image, which contains all the tools used in this project:
```
# 1. Connect to GCP VM and pull latest version of the docker image

ssh -L 8888:0.0.0.0:8888 $USER@00.000.000.000
docker pull stevetsa/versa_ab_resist:latest

# 2. Create directory to store results (this folder will persist on your host machine when you exit out of the Docker container)
mkdir -p test
chmod -R 777 test

# 3. Run the docker image and mount current directory (and all downstream directories, including "test") in the same path inside the container
docker run -it --rm -v `pwd`:`pwd` -w `pwd` -p 8888:8888 stevetsa/versa_ab_resist:latest

### Follow on-screen directions to open a Jupyter Notebook in a browser.  Subsequent steps in the pipeline can be run directly in the Notebook.   
```
Please see for further information: [How to use and run a Docker image](https://github.com/NCBI-Hackathons/Cancer_Epitopes_CSHL/blob/master/doc/Docker.md)

### Creating data library for mapping accessions 
The CARD database is used to obtain gene, orgranism, and drug-related information for the sequence hits obtained from MAGIC-BLAST. The latest version of this data can be downloaded from [CARD](https://card.mcmaster.ca/download)
The following are required: 
1. [card-data](https://card.mcmaster.ca/download/0/broadstreet-v2.0.2.tar.gz)
2. [card-ontology](https://card.mcmaster.ca/download/5/ontology-v2.0.2.tar.gz)
3. [card-prevalence](https://card.mcmaster.ca/download/6/prevalence-v3.0.1.tar.gz)

These need to be downloaded and unzipped into the 'lib' directory 

### Workflow Diagram
![workflow](https://github.com/NCBI-Hackathons/Bugs_And_Drugs/blob/master/BAD%20workflow.jpg "Workflow")

## Workflow Steps
### Input File Format

1. SRA RUN IDs in id.txt   
2. SRA BioProject ID  
3. FASTQ files  

### Jupyter Notebook

The Notebook is used to run the pipeline interactively using the computing resources in the GCP VM.  

### Docker Image

The Docker image contains the Jupyter sever and all the tools used in this pipeline.

## Output

![kronasample](https://github.com/NCBI-Hackathons/Bugs_And_Drugs/blob/master/Slide1.jpg)
Sample output display courtesy of [Krona](https://github.com/NCBI-Hackathons/Bugs_And_Drugs/blob/master/Slide1.jpg).
An interactive sample can be accessed at this [link](http://marbl.github.io/Krona/examples/phymmbl.krona.html?collapse=false&color=true&key=false).

## Future Directions
* Include MINion data from third-generation sequencing
* Expand number of databases utilized to run alignments
* Build in more information, such as time and geographical information to map evolution rates
* Implement machine learning analysis

## References
Jia et al. 2017. CARD 2017: expansion and model-centric curation of the Comprehensive Antibiotic Resistance Database. Nucleic Acids Research, 45, D566-573.

Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: 1 approved with reservations]. F1000Research 2017, 6:1971
(doi: 10.12688/f1000research.12781.1)

Wright, G. (2007). The antibiotic resistome: the nexus of chemical and genetic diversity. Nature Reviews Microbiology. Volume 5. pp. 175-186. doi: 10.1038/nrmicro1614
