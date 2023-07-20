
# obtain from: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags
ARG NVCR_CUDA=nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu20.04
FROM ${NVCR_CUDA} as cuda

FROM ucsdets/scipy-ml-notebook:2023.2-stable

COPY --from=cuda /usr/local/cuda-11.8 /usr/local/cuda-11.8

USER root
RUN ln -s cuda-11.8 /usr/local/cuda && ln -s cuda-11.8 /usr/local/cuda-11

USER jovyan
