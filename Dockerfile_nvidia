FROM python:3.12
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade \
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
    git \
    wget \
    g++ \
    libglib2.0.0 \
    libqt5x11extras5 \
    freeglut3-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
            
RUN pip install pyqt5 cupy-cuda12x;

WORKDIR /
RUN git clone https://github.com/HaseloffLab/CellModeller.git; \
    cd CellModeller && pip install -e .;
    
RUN echo 'python /CellModeller/Scripts/CellModellerGUI.py \n\
alias cmgui="python /CellModeller/Scripts/CellModellerGUI.py"' >> /root/.bashrc

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
RUN ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ENTRYPOINT ["python", "/CellModeller/Scripts/CellModellerGUI.py"]
