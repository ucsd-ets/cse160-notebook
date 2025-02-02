FROM nvidia/cuda:12.2.2-devel-ubuntu22.04
USER root

#====== Instructor Addition ======

RUN apt-get update && apt-get install -y wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y build-essential \
                        git \
                        llvm \
                        libclang-cpp-dev \
                        llvm-dev \
                        clang \
                        libclang-dev \
                        cmake \
                        pkg-config \
                        make \
                        ninja-build \
                        intel-oneapi-runtime-libs \
                        opencl-headers \
                        ocl-icd-libopencl1 \
                        ocl-icd-dev \
                        ocl-icd-opencl-dev \
                        libhwloc-dev \
                        clinfo \
                        dialog \
                        apt-utils \
                        libxml2-dev \
                        netcat \
                        openssh-server \
                        vim \
                        gdb \
                        valgrind \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# NVIDIA does not provide OpenCL passthru.
# POCL supports a CUDA-based OpenCL driver
RUN git clone https://github.com/pocl/pocl.git /pocl
WORKDIR /pocl
RUN git checkout v6.0
RUN mkdir build
WORKDIR /pocl/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DENABLE_CUDA=ON .. && \
    make -j && \
    make install && \
    rm -rf /pocl

#====== End Instructor Addition ===


#ARG PYTHON_VERSION=python-3.9.5
#FROM jupyter/base-notebook:$PYTHON_VERSION
#USER root
#
## see https://github.com/phusion/baseimage-docker/issues/319#issuecomment-1058835363
#ENV DEBIAN_FRONTEND noninteractive
#ENV DEBCONF_NOWARNINGS="yes"
#
#RUN apt-get update -y && \
#    apt-get -qq install -y --no-install-recommends \
#    git \
#    curl \
#    rsync \
#    unzip \
#    less \
#    nano \
#    vim \
#    cmake \
#    tmux \
#    screen \
#    gnupg \
#    htop \
#    wget \
#    openssh-client \
#    openssh-server \
#    p7zip \
#    apt-utils \
#    jq \
#    p7zip-full \
#    build-essential \
#    netcat \
#    && apt-get clean && rm -rf /var/lib/apt/lists/* && \
#    chmod g-s /usr/bin/screen && \
#    chmod 1777 /var/run/screen
#
#######################################
## Now add in CUDA-11.8 tools/libraries
#COPY --from=nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu20.04 /usr/local/cuda-11.8 /usr/local/cuda-11.8
#RUN ln -s cuda-11.8 /usr/local/cuda && ln -s cuda-11.8 /usr/local/cuda-11
#
## Configure dynamic library locations (similar to LD_LIBRARY_PATH)
#RUN echo '/usr/local/cuda/targets/x86_64-linux/lib' >> /etc/ld.so.conf.d/000_cuda.conf && \
#    echo '/usr/local/cuda-11/targets/x86_64-linux/lib' >> /etc/ld.so.conf.d/989_cuda-11.conf && \
#    ( echo '/usr/local/nvidia/lib'; echo '/usr/local/nvidia/lib64' ) >> /etc/ld.so.conf.d/nvidia.conf && \
#    ldconfig 
#
#ENV CUDA_HOME=/usr/local/cuda
#
#ENV PATH="${CUDA_HOME}/bin:${PATH}"
#
############################################
## Remainder of install as nonprivleged user
#
#USER jovyan
#
## nbgrader requires some variables set to just run the notebook server
#ENV NBGRADER_COURSEID="NA"
#ENV JUPYTERHUB_USER=${NB_USER}
#
## Install jupyterlab extensions
#RUN pip install jupyterlab-github jupyterlab-latex jupyterlab-git \
#    jupyterlab-fasta jupyterlab-pullrequests jupyterlab-geojson && \
#    pip cache purge
#
## Datascience packages
#RUN pip install dpkt \
#    nose \
#    datascience && \
#    python -c 'import matplotlib.pyplot' && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER && \
#    pip cache purge
#
#WORKDIR /home/jovyan
#
#USER jovyan
#
# ENV PATH=/usr/local/cuda/bin:$PATH \
#     LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# EXAMPLE
# RUN wget libraries \
#     install ...
