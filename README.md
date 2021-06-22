# CellModeller Docker Container
[![Docker Hub](https://img.shields.io/docker/v/avimanyu786/cellmodeller/4.3.1?label=Docker%20Hub)](https://hub.docker.com/r/avimanyu786/cellmodeller)

CellModeller is a multicellular modelling framework created by Tim Rudge, PJ Steiner, and Jim Haseloff, University of Cambridge. These Docker Hub images are an attempt to simplify the process of deploying the graphical user interface of CellModeller within a very few steps. The images have been built by extensively modifying Ubuntu 18.04 based Docker Hub images with several other essential packages. This approach works with both NVIDIA and AMD GPUs.

## 1. Prerequisites

### Operating System

The images have been tested on Ubuntu 18.04 as well as Ubuntu 20.04 but you are free to test them on other platforms.

### NVIDIA GPUs

Make sure you have installed the Nvidia Drivers(>=v390) on your Linux system. [Here](https://linuxhint.com/install-nvidia-drivers-linux/) is a distribution wise coverage. You would also require Nvidia Container Runtime. The installation steps are described [here](https://github.com/NVIDIA/nvidia-container-runtime) based on different distros.

### AMD GPUs

Download the Radeon™ Software for Linux® Driver for Ubuntu from [this page](https://www.amd.com/en/support/graphics/amd-radeon-2nd-generation-vega/amd-radeon-2nd-generation-vega/amd-radeon-vii). The installation steps are described [here](https://amdgpu-install.readthedocs.io/en/latest/) for different Linux distributions. On your host operating system, use the `amdgpu-install` [script](https://amdgpu-install.readthedocs.io/en/latest/install-script.html)  to install the AMDGPU Open Source drivers both for hardware older or newer than Vega 10. The AMD GPU docker image has been built for both.

Install Docker. On Ubuntu, you can run the following steps:

`sudo apt update`

`sudo apt install docker.io`

After installation, run:

`sudo groupadd docker`

It may already exist after Docker was installed. Nevertheless, add your Linux username to the group:

`sudo usermod -aG docker $USER`

Reboot the system.

Make sure you can run Docker as non-root user:

`docker run hello-world`

Run Docker on every boot so you wouldn't need to do that whenever you run CellModeller:

`sudo systemctl enable docker`

## 2. Create a directory for the results of your simulations

The following command has to be run on the host system's terminal:

`mkdir -p ~/cellmodeller/data`

You will be able to access this inside your CellModeller container as `/data`.

## 3. Using the Container

Permit your Linux username on the local machine to connect to the X windows display with the following command:

`xhost +local:username`

With the following command you can now directly run the GUI in one go:

### NVIDIA GPUs

`docker run --rm -it --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v ~/cellmodeller/data:/data --name cmgui avimanyu786/cellmodeller:nvidia-gpu`

In case you have more than one GPU on your system and want to run CellModeller on a specific GPU device, you would have to change the `--gpus all` flag to `--gpus 0`, 0,1 and so on being the specific Nvidia GPUs.

### AMD GPUs

`docker run --rm -it --device=/dev/kfd --device=/dev/dri --group-add video -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v ~/cellmodeller/data:/data --name cmgui avimanyu786/cellmodeller:amd-gpu`

In case you have more than one GPU on your system and want to run CellModeller on a specific GPU device, you would have to change the `device=/dev/dri` flag to `device=/dev/dri/card0`, card0,card1 and so on being the specific AMD GPUs. You would also need to add another `--device=/dev/dri/renderDXXX` flag. To know the value of XXX and the card information, run `ls /dev/dri`.

The first run will take some time as it would download the new image. If you close the GUI window after it finally launches, running the `cmgui` command in the container's terminal can bring it up again.

For batch mode, use `python CellModeller/Scripts/batch.py <model file name>`. You can launch them from `/data` through the container which is nothing but `/home/username/cellmodeller/data` on your host system.

## 4. Exiting the CellModeller Container and resetting permissions

When you want to quit the session, simple type `exit` in the container's terminal and you will come back to your host terminal session.

Remove the previously allotted permissions with:

`xhost -local:username`

Reown the root owned directories inside `~/cellmodeller/data` as your Linux username with:

`sudo chown -R username:username ~/cellmodeller/data/`

This container was built with several attempts, tweaks and modifications. Hope this container image makes it much easier for you to deploy, use or develop the framework.
