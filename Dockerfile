#Please note that the final image was committed with several changes to make it 
#an operational CellModeller container after this Dockerfile was used to build the initial image.
#For more details, see https://github.com/HaseloffLab/CellModeller/issues/23#issuecomment-669260388
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    mesa-utils \
    ocl-icd-libopencl1 \
    opencl-headers \
    clinfo \
    glmark2 \
    git \
    wget \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
