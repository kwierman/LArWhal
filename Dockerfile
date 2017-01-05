FROM nvidia/cuda

MAINTAINER Kevin Wierman <kevin.wierman@pnnl.gov>

RUN apt-get  update -y
RUN apt-get install -y -q wget curl git build-essential cmake python2.7 python2.7-dev python-dev python-pip libx11-dev libxpm-dev libxft-dev libxext-dev libpng3 libjpeg8 gfortran libssl-dev libpcre3-dev libgl1-mesa-dev libglew1.5-dev libftgl-dev libmysqlclient-dev libfftw3-dev libcfitsio3-dev graphviz-dev libavahi-compat-libdnssd-dev libldap2-dev libxml2-dev libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine-dev libeigen3-dev libtbb-dev libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
RUN apt-get install -y --no-install-recommends libboost-all-dev
RUN apt-get install -y libatlas-base-dev 
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev
RUN apt-get install -y libopencv-dev python-opencv

WORKDIR /tmp
COPY requirements.txt /tmp/
RUN pip install cython>=0.21
RUN pip install -r /tmp/requirements.txt

#GET ROOT6.06.08
RUN wget https://root.cern.ch/download/root_v6.06.08.Linux-ubuntu14-x86_64-gcc4.8.tar.gz
RUN tar -xvf root*
RUN rm -rf /usr/local/man
RUN cp -rf root/* /usr/local/.
#RUN /bin/bash -c "git clone --depth 1 http://root.cern.ch/git/root.git -b v6-06-08 --single-branch \
#   && cd root \
#   && ./configure --prefix=/usr/local --minimal --disable-x11 \
#           --enable-astiff --enable-builtin-afterimage --enable-builtin_ftgl --enable-builtin_glew --enable-builtin_pcre --enable-builtin-lzma \
#           --enable-python --enable-roofit --enable-xml --enable-minuit2 \
#           --disable-xrootd --fail-on-missing \
#   && make -j4 install \
#   && cd .. \
#   && rm -rf root"

RUN mkdir /larbys
WORKDIR /larbys

#INSTALL LARCV
RUN git clone https://github.com/LArbys/LArCV
WORKDIR /larbys/LArCV
RUN  git checkout c420d9664fd5188f3abd1163853969c8b1dd0519
RUN /bin/bash -c "source /usr/local/bin/thisroot.sh && source configure.sh && make"

#INSTALL LArCaffe
WORKDIR /larbys
RUN git clone https://github.com/LArbys/caffe
WORKDIR /larbys/caffe
RUN /bin/bash -c "source /usr/local/bin/thisroot.sh && source /larbys/LArCV/configure.sh \
  && ./configure.sh \ 
  && make \
  && make pycaffe"

COPY setup.sh /home/
WORKDIR /home/
CMD bash
