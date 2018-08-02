FROM debian:sid

MAINTAINER Maxime Werlen <maxime@werlen.fr>
ENV DEBIAN_FRONTEND noninteractive

ENV TERM xterm

# Installing some dependencies
RUN apt-get update && apt-get install -y \
  build-essential gcc cmake make git tar wget

RUN apt-get upgrade -y


# Fixing timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Some alias
RUN echo "alias ll='ls -alh --color=auto'" >> /root/.bashrc
RUN echo "alias rm='rm -i'" >> /root/.bashrc
RUN echo "alias cp='cp -i'" >> /root/.bashrc

# Preparing mount point
# RUN mkdir /usr/local/src/visiona
WORKDIR /usr/local/src

# Installing openCV
RUN git clone --branch 2.4.13.6 https://github.com/opencv/opencv
RUN mkdir /usr/local/src/opencv/build
WORKDIR /usr/local/src/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local/ ..
RUN make -j$(nproc) && make install

# Resetting current folder
WORKDIR /usr/local/src

# Installing libconfig
RUN apt-get install libconfig++-dev -y

# Installing eigen3
RUN apt-get install libeigen3-dev -y

# Copying visiona
RUN git clone https://github.com/mwerlen/visiona
WORKDIR /usr/local/src/visiona
RUN rm -f CMakeCache.txt
RUN cmake . && make && make install

CMD ["/bin/bash"]
