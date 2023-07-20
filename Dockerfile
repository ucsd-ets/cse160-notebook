FROM ucsdets/scipy-ml-notebook:2023.2-stable

# to conserve disk space during build, 
# scripts/build-intermediate-nvcr-cuda.sh (run by github actions prior to this build) 
# separately constructs the following intermediate container 
COPY --from=intermediate-nvcr-cuda:latest /usr/local/cuda-11.8 /usr/local/cuda-11.8

USER root
RUN ln -s cuda-11.8 /usr/local/cuda && ln -s cuda-11.8 /usr/local/cuda-11

USER jovyan
