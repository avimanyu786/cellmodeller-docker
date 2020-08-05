# CellModeller Docker Container

[CellModeller](https://haselofflab.github.io/CellModeller) is a multicellular modelling framework created by Tim Rudge, PJ Steiner, and Jim Haseloff, University of Cambridge. This docker hub image an attempt to simplify the process of deploying the graphical user interface of CellModeller with a very few steps. The image has been built by extensively modifying the nvidia/opengl ubuntu 18.04 docker hub image with several other essential packages. Currently this works only with NVIDIA GPUs but AMD GPU support is also a work in progress.

## 1. Prerequisites

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

Make sure you have installed the Nvidia Drivers on your Linux system. [Here](https://linuxhint.com/install-nvidia-drivers-linux/) is a distribution wise coverage. You would also require the Nvidia Runtime Container Toolkit. The installation steps are described [here](https://github.com/NVIDIA/nvidia-docker) based on different distros.


## 2. Create a directory for the results of your simulations

The following command has to be run on the host system's terminal:

`mkdir -p ~/cellmodeller/data`

You will be able to access this inside your CellModeller container as `/data`.

## 3. Using the Container

Permit your Linux username on the local machine to connect to the X windows display with the following command:

`xhost +local:username`

With the following command you can now directly run the GUI in one go:

`docker run --rm -it --gpus all -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/cellmodeller/data:/data --name cmgui avimanyu786/cellmodeller:4.3.1`

The first run will take some time as it would download the new image. If you close the GUI window after it finally launches, running the `cmgui` command in the container's terminal can bring it up again.

For batch mode, use `python CellModeller/Scripts/batch.py <model file name>`. You can launch them from `/data` through the container which is nothing but `/home/username/cellmodeller/data` on your host system.

In case you have more than one GPU on your system and want to run CellModeller on a specific GPU device, you would have to change the `--gpus all` flag to `--gpus 0`, 0,1 and so on being the specific Nvidia GPUs.

## 4. Exiting the CellModeller Container and resetting permissions

When you want to quit the session, simple type `exit` in the container's terminal and you will come back to your host terminal session.

Remove the previously allotted permissions with:

`xhost -local:username`

Reown the root owned directories inside `~/cellmodeller/data` as your Linux username with:

`sudo chown -R username:username ~/cellmodeller/data/`

This container was built with several attempts, tweaks and modifications. Hope this container image makes it much easier for you to deploy, use or develop the framework.
