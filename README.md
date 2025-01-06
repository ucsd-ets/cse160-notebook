# nvcr-cuda

# Instructions

launch.sh -i ghcr.io/ucsd-ets/cse160-notebook:main

After launch run:

```
mkdir -p $HOME/.opencl/vendors
echo "/usr/local/nvidia/lib64/libnvidia-opencl.so.525.53" > $HOME/.opencl/vendors/nvidia.icd
```
