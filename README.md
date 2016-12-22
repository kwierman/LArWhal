# LArWhal

A docker image for running the LArby's framework.

[![Build Status](https://travis-ci.org/kwierman/LArWhal.svg?branch=master)](https://travis-ci.org/kwierman/LArWhal) 

> *Note:* This build tends to time out due to the ROOT dependency. This is unavoidable until the canonical ROOT is updated to  `>=6.6`.

> *Note:* Currently the build is being tested with pre-compiled ROOT binaries instead of building from source. This may fail on certain platforms.

## How to build the image

~~~ bash
git clone https://github.com/kwierman/LArWhal
cd LArWhal
nvidia-docker build -t larbys/larwhal:v1 .
~~~

## Running the Image in a Container

~~~bash
nvidia-docker run -ti --name <your job name> larbys/larwhal
~~~

## Sharing Data with Container

Typically, for using a single container, the training data sample and project directories need to be shared. For simplicity, I put these in the

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
