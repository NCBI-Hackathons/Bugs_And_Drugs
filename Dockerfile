# Contents of the Dockerfile by Steve Ts and Jupyter Development Team.

# Ubuntu 16.04 (xenial) from 2018-02-28
# https://github.com/docker-library/official-images/commit/8728671fdca3dfc029be4ab838ab5315aa125181
#FROM ubuntu:xenial-20180228@sha256:e348fbbea0e0a0e73ab0370de151e7800684445c509d46195aef73e090a49bd6

FROM ubuntu:16.04
LABEL maintainer="Steve Tsang <mylagimail2004@yahoo.com>"

USER root
# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    ### Nastybugs dependencies
    build-essential \
    gcc-multilib \
    apt-utils \
    autotools-dev \
    autoconf \
    autogen \
    automake \
    zlib1g-dev \
    vim-common \
    libncurses5-dev \
    autotools-dev \
    autoconf \
    perl \
    r-base \
    python \
    python-pip \
    libbz2-dev \
    liblzma-dev \
    libz-dev \
    ncurses-dev \
    libcurl3 \
    libcurl4-openssl-dev \
    libxml2-dev \
    ###  Jupyter dependencies
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
### dependencies for Nastybugs2
    python3 \
    python3-pip \
    pkg-config \
    python-dev \
    graphviz \
    libgraphviz-dev \ 
    libtool \
    libgd-gd2-perl \
#    autotools-dev \
#    autoconf \
#    autogen 
#    automake \
    curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
## modified to ubuntu user
    NB_USER=ubuntu \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

ADD scripts/fix-permissions /usr/local/bin/fix-permissions
# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd /etc/group && \
    fix-permissions $HOME && \
    fix-permissions $CONDA_DIR

USER $NB_UID

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION 4.4.10
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "bec6203dbb2f53011e974e9bf4d46e93 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install Jupyter Notebook and Hub
RUN conda install --quiet --yes \
    'notebook=5.4.*' \
    'jupyterhub=0.8.*' \
    'jupyterlab=0.32.*' && \
    conda clean -tipsy && \
    jupyter labextension install @jupyterlab/hub-extension@^0.8.1 && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER root
####
#Install Nastybugs stuff - https://github.com/stevetsa/MetagenomicAntibioticResistance/blob/master/Dockerfile
WORKDIR /opt
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/samtools/htslib.git
WORKDIR /opt/htslib
RUN autoheader
RUN autoconf
RUN ./configure
RUN make
RUN make install
ENV PATH "$PATH:/opt/htslib/"

WORKDIR /opt
RUN git clone https://github.com/samtools/samtools.git
WORKDIR /opt/samtools
RUN autoheader
RUN autoconf -Wno-syntax
RUN ./configure    # Optional, needed for choosing optional functionality
RUN make
RUN make install
ENV PATH "$PATH:/opt/samtools/"

WORKDIR /opt/
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.7.1+-x64-linux.tar.gz
RUN tar xvzf ncbi-blast-2.7.1+-x64-linux.tar.gz
WORKDIR /opt/ncbi-blast-2.7.1+
ENV PATH "$PATH:/opt/ncbi-blast-2.7.1+/"

WORKDIR /opt/
RUN wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.0/sratoolkit.2.9.0-ubuntu64.tar.gz
RUN tar xvzf sratoolkit.2.9.0-ubuntu64.tar.gz
WORKDIR /opt/sratoolkit.2.9.0-ubuntu64
ENV PATH "$PATH:/opt/sratoolkit.2.9.0-ubuntu64/bin/"
RUN apt-get install -y unzip

WORKDIR /opt/
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/1.3.0/ncbi-magicblast-1.3.0-x64-linux.tar.gz
RUN tar xvzf ncbi-magicblast-1.3.0-x64-linux.tar.gz
WORKDIR /opt/ncbi-magicblast-1.3.0
ENV PATH "$PATH:/opt/ncbi-magicblast-1.3.0/bin/"

WORKDIR /opt/
RUN git clone https://github.com/agordon/fastx_toolkit.git
WORKDIR /opt/fastx_toolkit
###
RUN git clone https://github.com/agordon/libgtextutils.git
WORKDIR /opt/fastx_toolkit/libgtextutils
RUN ./reconf
RUN ./configure
RUN make
RUN make install
###
WORKDIR /opt/fastx_toolkit
RUN ./reconf
RUN ./configure
RUN make
RUN make install
RUN cpan 'PerlIO::gzip'
RUN cpan 'GD::Graph::bars'

## CARD RGL tool
RUN apt-get install -y git python3 python3-dev python3-pip ncbi-blast+ prodigal wget && \
    wget http://github.com/bbuchfink/diamond/releases/download/v0.8.36/diamond-linux64.tar.gz && \
    tar xvf diamond-linux64.tar.gz && \
    mv diamond /usr/bin

WORKDIR /opt
RUN wget https://card.mcmaster.ca/download/1/software-v4.1.0.tar.gz
RUN tar xvf software-v4.1.0.tar.gz
RUN tar xvzf 4.1.0.tar.gz
WORKDIR /opt/rgi-4.1.0
RUN pip3 install -r requirements.txt && \
    pip3 install . && \
    bash test.sh 

WORKDIR /
#RUN git clone https://github.com/stevetsa/MetagenomicAntibioticResistance.git

# Install Nastybugs2

RUN pip install --upgrade pip
RUN pip install pygraphviz
RUN pip install seaborn
RUN pip3 install numpy
RUN pip3 install pandas
RUN pip3 install pysam
RUN pip3 install matplotlib
RUN pip3 install snakemake
RUN pip3 install sequana

#########
RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda
RUN conda install bowtie2
#########

USER root

EXPOSE 8888
WORKDIR $HOME
RUN pip install qgrid

RUN jupyter nbextension enable --py --sys-prefix qgrid
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install qgrid

WORKDIR /opt
RUN git clone https://github.com/marbl/Krona.git
WORKDIR /opt/Krona/KronaTools
RUN ./install.pl --prefix /usr/local/bin --taxonomy /opt/Krona/KronaTools
#RUN apt-get install -y curl
#RUN ./updateTaxonomy.sh
#RUN ./updateAccessions.sh

#RUN cp -r /opt/sratoolkit.2.9.0-ubuntu64/bin/* /usr/local/bin/.

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY scripts/start.sh /usr/local/bin/
COPY scripts/start-notebook.sh /usr/local/bin/
COPY scripts/start-singleuser.sh /usr/local/bin/
COPY scripts/jupyter_notebook_config.py /etc/jupyter/
RUN fix-permissions /etc/jupyter/

# Switch back to non-root user to avoid accidental container runs as root
USER $NB_UID

####
# Get notebooks
#WORKDIR  /home/$NB_USER/work
#RUN git clone https://github.com/sbl-sdsc/mmtf-workshop-2018.git
#WORKDIR $HOME

