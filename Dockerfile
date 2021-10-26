FROM nvcr.io/nvidia/cuda:11.2.2-devel-ubuntu20.04

USER root
RUN apt-get update -y && \
    ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -qq install -y --no-install-recommends \
    git \
    curl \
    rsync \
    unzip \
    less \
    nano \
    vim \
    openssh-client \
    cmake \
    tmux \
    screen \
    gnupg \
    htop \
    wget \
    p7zip \
    p7zip-full && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    chmod g-s /usr/bin/screen && \
    chmod 1777 /var/run/screen && \
    dpkg-reconfigure --frontend noninteractive tzdata

USER jovyan
WORKDIR /home/jovyan
