ARG PYTHON_VERSION=python-3.9.5
FROM jupyter/base-notebook:$PYTHON_VERSION
USER root

# see https://github.com/phusion/baseimage-docker/issues/319#issuecomment-1058835363
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS="yes"

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

######################################
# Now add in CUDA-11.2 tools/libraries
COPY --from=nvcr.io/nvidia/cuda:11.2.0-devel-ubuntu20.04 /usr/local/cuda-11.2 /usr/local/cuda-11.2
RUN ln -s cuda-11.2 /usr/local/cuda && ln -s cuda-11.2 /usr/local/cuda-11

# Configure dynamic library locations (similar to LD_LIBRARY_PATH)
RUN echo '/usr/local/cuda/targets/x86_64-linux/lib' >> /etc/ld.so.conf.d/000_cuda.conf && \
    echo '/usr/local/cuda-11/targets/x86_64-linux/lib' >> /etc/ld.so.conf.d/989_cuda-11.conf && \
    ( echo '/usr/local/nvidia/lib'; echo '/usr/local/nvidia/lib64' ) >> /etc/ld.so.conf.d/nvidia.conf

###########################################
# Remainder of install as nonprivleged user

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
