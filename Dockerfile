ARG PYTHON_VERSION=python-3.9.5
FROM jupyter/base-notebook:$PYTHON_VERSION
# coerce change in all notebook
USER root

# see https://github.com/phusion/baseimage-docker/issues/319#issuecomment-1058835363
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS="yes"

COPY --from=nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu20.04 /usr/local/cuda-11.8 /usr/local/cuda-11.8

RUN ln -s cuda-11.8 /usr/local/cuda && ln -s cuda-11.8 /usr/local/cuda-11

RUN apt-get update -y && \
    apt-get -qq install -y --no-install-recommends \
    git \
    curl \
    rsync \
    unzip \
    less \
    nano \
    vim \
    cmake \
    tmux \
    screen \
    gnupg \
    htop \
    wget \
    openssh-client \
    openssh-server \
    p7zip \
    apt-utils \
    jq \
    p7zip-full \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chmod g-s /usr/bin/screen && \
    chmod 1777 /var/run/screen

USER jovyan

# nbgrader requires some variables set to just run the notebook server
ENV NBGRADER_COURSEID="NA"
ENV JUPYTERHUB_USER=${NB_USER}

# Install jupyterlab extensions
RUN pip install jupyterlab-github jupyterlab-latex jupyterlab-git \
    jupyterlab-fasta jupyterlab-pullrequests jupyterlab-geojson && \
    pip cache purge

# Datascience packages
RUN pip install dpkt \
    nose \
    datascience && \
    python -c 'import matplotlib.pyplot' && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    pip cache purge

WORKDIR /home/jovyan

USER jovyan
