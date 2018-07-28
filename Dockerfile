FROM debian:sid

MAINTAINER Maxime Werlen <maxime@werlen.fr>
ENV DEBIAN_FRONTEND noninteractive

ENV TERM xterm

# Installing some dependencies
RUN apt-get update --fix-missing \
    && apt-get dist-upgrade -y \
    && apt-get install -y build-essential gcc cmake make vim less locales autopkgtest \
                autoconf automake libtool flex bison
    && apt-get autoremove -y

# Fixing timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


CMD ["/bin/bash"]
