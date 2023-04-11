FROM ubuntu:latest

LABEL MAINTAINER="Pedro Rodrigues <pedromiguelrodrigues2000@gmail.com>, Samuel Carinhas <samuelsantos.c.2001@gmail.com>"
LABEL VERSION="0.1.0"

# non-interactive frontend during build
ARG DEBIAN_FRONTEND=noninteractive

# Environment Variables
ENV MOOSHAK_VERSION=1.6.6

# Update/Upgrade System
RUN apt-get update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install apt-utils

# Install Packages
RUN apt-get install -y locales supervisor apt-transport-https ca-certificates

# Set Locale (UTF-8) 
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
  locale-gen

# More Environment Variables
ENV LC_ALL=en_US.UTF-8 
ENV LANG=en_US.UTF-8 
ENV LANGUAGE=en_US.UTF-8

# More packages
RUN apt-get install -y gcc make tcl apache2 apache2-suexec-custom \
  lpr time cron host rsync libxml2-utils xsltproc curl vim sendmail \
  sasl2-bin

# Install Tooling 
RUN apt-get install -y build-essential default-jre default-jdk pypy3 

# Cleanup
RUN apt-get clean 
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*

# Import Configuration Files
COPY ./config/userdir.conf  /etc/apache2/mods-available
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install & Configure Apache2
WORKDIR /etc/apache2/mods-enabled

RUN ln -sf ../mods-available/userdir.conf
RUN ln -sf ../mods-available/userdir.load
RUN ln -sf ../mods-available/cgi.load 
RUN ln -sf ../mods-available/suexec.load

# Download & Install Mooshak
WORKDIR /tmp

ADD https://mooshak.dcc.fc.up.pt/download/mooshak-${MOOSHAK_VERSION}.tgz mooshak-${MOOSHAK_VERSION}.tgz
RUN tar xvzf mooshak-${MOOSHAK_VERSION}.tgz
RUN cd /tmp/mooshak-${MOOSHAK_VERSION} && \
  sed -e 's/proc check_suexec {} {/proc check_suexec {} { return;/' < install > install-modded  &&\
  chmod +x install-modded && \
  ./install-modded &&\
  cd .. && rm -rf /tmp/mooshak*

# Default Workdir
WORKDIR /home/mooshak

# Expose Ports
EXPOSE 80

# Expose Volumes
VOLUME /home/mooshak/data
VOLUME /etc/apache2

# Healthcheck
HEALTHCHECK --interval=10s --timeout=30s --start-period=5s --retries=3 \
  CMD curl http://localhost:80/ || exit 1

# Run
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
