<!--<img src="https://github.com/kwierman/LArWhal/blob/master/larwhal.png?raw=true" data-canonical-src="https://github.com/kwierman/LArWhal/blob/master/larwhal.png?raw=true" width="100" />-->
# LArWhal 

A dockerfile for running the LArby's framework image.

[![Build Status](https://travis-ci.org/kwierman/LArWhal.svg?branch=master)](https://travis-ci.org/kwierman/LArWhal) 

> _Note:_ This build tends to time out due to the ROOT dependency. This is unavoidable until the canonical ROOT is updated to  `>=6.6`.

> _Note:_ Currently the build is being tested with pre-compiled ROOT binaries instead of building from source. This may fail on certain platforms.

## How to build the image

This guide assumes that the user and/or developer is already familiar with the [Docker user guide](https://docs.docker.com/engine/userguide/intro/). As such, this guide is meant to be more of a reference for getting projects depending on this software off the ground quickly.

~~~ bash
git clone https://github.com/kwierman/LArWhal
cd LArWhal
nvidia-docker build -t larbys/larwhal:latest .
~~~

## Running the Image in a Container

~~~ bash
nvidia-docker run -ti --name <your job name> larbys/larwhal
~~~

## Sharing Data with Container

Typically, for using a single container, the training data sample and project directories need to be shared. For simplicity, I put these on a RAID drive attached to the host machine. Therefore, in order to share the files with the container, the `-v` flag is used as such:

~~~ bash
nvidia-docker run -ti --name <your job name> -v /raid/data:/data larbys/larwhal
~~~

### Running with X Forwarding

Add the following options to run 

~~~ bash
nvidia-docker run -ti \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       --name <your job name> \
       larbys/larwhal
~~~

### Detaching from Container

By default, you should be able to use `ctl-p`, `ctl-q` to detach.

### Reattaching to Container

Run `nvidia-docker ps` to see the running containers. Find the one with the `larbys/larwhal:v1` tag or the `<your job name>` attached. Then issue:

~~~ bash
nvidia-docker attach <name or ID>
~~~

> *Note:* In this case, the container is using the `nvidia-docker` commands. On some NVidia produced systems, the vanilla `docker` binary has been aliased to `nvidia-docker`.

## Running Caffe within the Container

In order to setup the environment, the following command needs to be issued first:

~~~ bash
source /home/setup.sh
~~~

The caffe executable can be communicated with using the path `/larbys/caffe/build/tools/caffe`. Thus, to commence training, the following example works for a network `kwierman_sp_resnet.prototxt`

~~~ bash
cd /data/kwierman/resnet
/larbys/caffe/build/tools/caffe train --solver=kwierman_sp_resnet_solver.prototxt --gpu=3
~~~
