FROM ubuntu:focal

MAINTAINER Gonzalo Nahuel Vaca <vacagonzalo@gmail.com>

ARG UBUNTU_MIRROR
RUN [ -z "${UBUNTU_MIRROR}" ] || sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list 

RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  autoconf \
  bc \
  bison \
  build-essential \
  chrpath \
  cpio \
  diffstat \
  expect \
  flex \
  gawk \
  gcc-multilib \
  git \
  gnupg \
  gzip \
  iproute2 \
  kmod \
  lib32z1-dev \
  libglib2.0-dev \
  libgtk2.0-0 \
  libidn11 \
  libncurses5-dev \
  libsdl1.2-dev \
  libselinux1 \
  libssl-dev \
  libtinfo5 \
  libtool \
  libtool-bin \
  locales \
  lsb-release \
  net-tools \
  pax \
  python \
  rsync \
  screen \
  socat \
  sudo \
  texinfo \
  tftpd \
  tofrodos \
  u-boot-tools \
  unzip \
  update-inetd \
  wget \
  xterm \
  xvfb \
  xxd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386 &&  apt-get update &&  \
      DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
      zlib1g:i386 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ARG PETA_VERSION
ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

#make a Dev user
RUN adduser --disabled-password --gecos '' dev && \
  usermod -aG sudo dev && \
  echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+rx /${PETA_RUN_FILE} && \
  chmod a+rx /accept-eula.sh && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u dev -i /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER dev
ENV HOME /home/dev
ENV LANG en_US.UTF-8
RUN mkdir /home/dev/workspace
WORKDIR /home/dev/workspace

#add dev tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/dev/.bashrc
