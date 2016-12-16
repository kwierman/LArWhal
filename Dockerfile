FROM nvidia/cuda

MAINTAINER Kevin Wierman <kevin.wierman@pnnl.gov>

RUN apt-get  update -y
RUN apt-get install -y -q wget curl git build-essential cmake python2.7-dev libx11-dev libxpm-dev libxft-dev libxext-dev libpng3 libjpeg8 gfortran libssl-dev libpcre3-dev libgl1-mesa-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio3-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine-dev libeigen3-dev libtbb-dev libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
RUN sudo apt-get install -y --no-install-recommends libboost-all-dev
RUN sudo apt-get install -y libatlas-base-dev 
RUN sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
RUN sudo apt-get install -y libopencv-dev python-opencv

WORKDIR /tmp

#GET ROOT6.06.08
RUN /bin/bash -c "git clone --depth 1 http://root.cern.ch/git/root.git -b v6-06-08 --single-branch \
   && cd root \
   && ./configure --prefix=/usr/local --minimal --disable-x11 \
           --enable-astiff --enable-builtin-afterimage --enable-builtin_ftgl --enable-builtin_glew --enable-builtin_pcre --enable-builtin-lzma \
           --enable-python --enable-roofit --enable-xml --enable-minuit2 \
           --disable-xrootd --fail-on-missing \
   && make -j2 \
   && make install \
   && cd .. \
   && rm -rf root"

RUN mkdir /larbys
WORKDIR /larbys

#INSTALL LARCV
RUN git clone https://github.com/LArbys/LArCV
WORKDIR /larbys/LArCV
RUN /bin/bash -c "source configure.sh && make"

#INSTALL LArCaffe
WORKDIR /larbys/LArCV
RUN git clone https://github.com/LArbys/caffe
RUN /bin/bash -c "source LArCV/configure.sh \
  && cd caffe \
  && ./configure.sh \ 
  && make \
  && make pycaffe"

# Define default command.
CMD bash
