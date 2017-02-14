FROM nvidia/cuda

MAINTAINER Kevin Wierman <kevin.wierman@pnnl.gov>

# System Packages
RUN apt-get  update -y
RUN apt-get install -y -q wget curl git build-essential cmake python2.7 python2.7-dev python-dev python-pip libx11-dev libxpm-dev libxft-dev libxext-dev libpng3 libjpeg8 gfortran libssl-dev libpcre3-dev libgl1-mesa-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio3-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libeigen3-dev libtbb-dev libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libatlas-base-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libopencv-dev python-opencv gcc-4.8 g++-4.8
RUN apt-get install -y --no-install-recommends libboost-all-dev

# Python environment Packages
WORKDIR /tmp
COPY requirements.txt /tmp/
RUN pip install cython>=0.21
RUN pip install -r /tmp/requirements.txt

# ROOT6.06.08
RUN git clone https://github.com/root-mirror/root
WORKDIR /tmp/root
RUN git tag -l
RUN git checkout -b v6-04-18 v6-04-18
RUN mkdir /tmp/rootbuild
WORKDIR /tmp/rootbuild
RUN cmake ../root
RUN make -j 4 install
WORKDIR /tmp
RUN rm -rf root*

RUN mkdir /larbys
WORKDIR /larbys

#INSTALL LARCV
RUN git clone https://github.com/LArbys/LArCV
WORKDIR /larbys/LArCV
RUN /bin/bash -c "source /usr/local/bin/thisroot.sh && source configure.sh && make"

#INSTALL LArCaffe
WORKDIR /larbys
RUN git clone https://github.com/HEP-DL/caffe
WORKDIR /larbys/caffe
RUN /bin/bash -c "source /usr/local/bin/thisroot.sh && source /larbys/LArCV/configure.sh \
  && ./configure.sh \ 
  && make \
  && make pycaffe"

COPY setup.sh /home/
WORKDIR /home/
CMD bash
