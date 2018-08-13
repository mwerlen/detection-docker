FROM debian:buster-slim

MAINTAINER Maxime Werlen <maxime@werlen.fr>
ENV DEBIAN_FRONTEND noninteractive

ENV TERM xterm

# Installing some dependencies
RUN apt-get update --fix-missing \
    && apt-get dist-upgrade -y \
    && apt-get install -y build-essential gcc cmake make vim less locales autopkgtest \
                autoconf automake libtool flex bison  git libgtk2.0-dev pkg-config \
                libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy \
                libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
                texinfo locate gdb\
    && apt-get autoremove -y

# Fixing timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Some alias
RUN echo "alias ll='ls -alh --color=auto'" >> /root/.bashrc
RUN echo "alias rm='rm -i'" >> /root/.bashrc
RUN echo "alias cp='cp -i'" >> /root/.bashrc
RUN echo "add-auto-load-safe-path /usr/local/src/visiona/.gdbinit" >> /root/.gdbinit

# Preparing mount point
RUN mkdir /usr/local/src/visiona

# Installing openCV
COPY opencv2 /usr/local/src/opencv2
RUN mkdir /usr/local/src/opencv2/build
WORKDIR /usr/local/src/opencv2/build
RUN cmake -DBUILD_SHARED_LIBS=OFF -D CMAKE_BUILD_TYPE=DEBUG -D CMAKE_INSTALL_PREFIX=/usr /usr/local/src/opencv2
RUN make && make install

# Installing libconfig
COPY libconfig /usr/local/src/libconfig
WORKDIR /usr/local/src/libconfig
RUN autoreconf && /usr/local/src/libconfig/configure --prefix=/usr
RUN make && make install

# Installing eigen3
COPY eigen3 /usr/local/src/eigen3
RUN mkdir /usr/local/src/eigen3/build
WORKDIR /usr/local/src/eigen3/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=debug /usr/local/src/eigen3 && make install

#Making eigen blas
RUN make blas

# Ca sert !
RUN updatedb

# Prepare to work
WORKDIR /usr/local/src/visiona/build
# Todo manually (folder visiona not copied but need to be mounted)
#RUN cmake /usr/local/src/visiona
#RUN make

CMD ["/bin/bash"]
