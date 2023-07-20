FROM ucsdets/datascience-notebook:2023.2-stable

COPY --from=nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu20.04 /usr/local/cuda-11.8 /usr/local/cuda-11.8

USER root
RUN ln -s cuda-11.8 /usr/local/cuda && ln -s cuda-11.8 /usr/local/cuda-11

USER jovyan
