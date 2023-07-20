#!/bin/bash

BDIR=`mktemp -d`
NVCR_REPO=nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu20.04

cd $BDIR

cat > Dockerfile <<EOM
# absolutely blank dockerfile
FROM scratch
USER root

# obtain from: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
COPY --from=${NVCR_REPO} /usr/local/cuda-11.8 /usr/local/cuda-11.8

EOM

docker build -t intermediate-nvcr-cuda:latest .

docker rmi ${NVCR_REPO}

