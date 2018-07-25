# Bugs and Drugs

*This pipeline builds on a previous NCBI hacakthon product, [Nastybugs](https://github.com/NCBI-Hackathons/MetagenomicAntibioticResistance), which is a simple method for extracting antimicrobial res
istance information from metagenomes
Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: 1 approved with reservations]. F1000Research 201
7, 6:1971
(doi: 10.12688/f1000research.12781.1)*

## Introduction

The resistome describes all antimicrobial resistance genes, including those found in pathogenic and non-pathogenic bacteria (Wright, G., et al.). While the antibiotic resistome is intrinsic to nearly all environments, particular interest has emerged in the context of human health and the treatment of diseases. Widespread use of antibiotics had led to the emergence of antimicrobial resistance in several strains of pathogenic bacteria. As a result, pressure has mounted to innovate new antimicrobial treatments against multi-drug resistant pathogens in the face of a potentially deadly public health crisis. Accurate tools predicting specific antibiotic resistance in a microbial sample may allow physicians to give more precise and effective treatments for infections, leading to better patient outcomes and reducing the rate of antimicrobial resistance. While progress has already been made within the private sector towards consolidating multiple antibiotic resistance databases, analyzing and visualizing the resulting data, there are still very few free and publicly accessible pipelines serving this purpose. Here, we present **Bugs and Drugs (B.A.D.)**, an open-source pipeline to analyze microbial samples for potentially antibiotic-resistant phenotypes and present pertinent results in a series of dynamic visualizations. 

## Software Dependencies
This program can be used as a standalone in a Jupyter notebook or run in a Docker container. Please ensure that Python version 3.5 or greater with Jupyter module  _**or**_ Docker is installed on your machine.

## Installation
### Jupyter Notebooks

### Docker
1. First, [install Docker](https://docs.docker.com/install/) if it is not already on your machine. On the Docker website, refer to the menu on the side to find the correct operating system and corresponding installation guide.
2. Enter the following from the command line to run the docker image:
```
# Pull latest version of docker image
docker pull stevetsa/metagenomicantibioticresistance:latest

# Run the docker image
docker run -v `pwd`:`pwd` -w `pwd` -i -t stevetsa/metagenomicantibioticresistance:latest

# Create directory to store results (this folder will persist on your host machine when you exit out of the Docker container)
mkdir test
```
Please see for further information: [How to use and run a Docker image](https://github.com/NCBI-Hackathons/Cancer_Epitopes_CSHL/blob/master/doc/Docker.md)

### Workflow Diagram
![workflow](https://github.com/NCBI-Hackathons/Versa_AB_Resist/blob/master/workflow2.png "Workflow")

## Workflow Steps
### Input File Format

### Jupyter Notebook
```
# CODE HERE
```
### Docker Container
```
# CODE HERE
```
## Output

## Future Directions

## References
Jia et al. 2017. CARD 2017: expansion and model-centric curation of the Comprehensive Antibiotic Resistance Database. Nucleic Acids Research, 45, D566-573.

Tsang H, Moss M, Fedewa G et al. NastyBugs: A simple method for extracting antimicrobial resistance information from metagenomes [version 1; referees: 1 approved with reservations]. F1000Research 2017, 6:1971
(doi: 10.12688/f1000research.12781.1)

Wright, G. (2007). The antibiotic resistome: the nexus of chemical and genetic diversity. Nature Reviews Microbiology. Volume 5. pp. 175-186. doi: 10.1038/nrmicro1614
