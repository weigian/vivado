# git source:  https://github.com/phwl/docker-vivado
# x11 bring-up: https://zhouyuqian.com/2021/06/01/docker-vivado

FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

ARG INSTALL_FILE="Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz"

RUN \
  sed -i -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list && \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get -y --no-install-recommends install \
    ca-certificates curl sudo xorg dbus dbus-x11 ubuntu-gnome-default-settings gtk2-engines \
    ttf-ubuntu-font-family fonts-ubuntu-font-family-console fonts-droid-fallback lxappearance && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
  echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ARG gosu_version=1.10
RUN \
  curl -SL "https://github.com/tianon/gosu/releases/download/${gosu_version}/gosu-$(dpkg --print-architecture)" \
    -o /usr/local/bin/gosu && \
  curl -SL "https://github.com/tianon/gosu/releases/download/${gosu_version}/gosu-$(dpkg --print-architecture).asc" \
    -o /usr/local/bin/gosu.asc && \
  #gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
  for server in \
  keyserver.ubuntu.com \
  ha.pool.sks-keyservers.net \
  pgp.mit.edu \
  ; do \
  gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || echo "Trying new server..."; \
  done && \
  gpg --verify /usr/local/bin/gosu.asc && \
  rm -rf /usr/local/bin/gosu.asc /root/.gnupg && \
  chmod +x /usr/local/bin/gosu

# vidao
RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential git gcc-multilib libc6-dev:i386 ocl-icd-opencl-dev libjpeg62-dev && \
  apt-get -y -f install && \
  apt-get -y install python && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

#COPY install_config.txt /vivado-installer/
COPY ${INSTALL_FILE} /vivado-installer/

RUN \
  cat /vivado-installer/${INSTALL_FILE} | tar zx --strip-components=1 -C /vivado-installer && \
  /vivado-installer/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    -e "Vivado HL Design Edition" -l "/tools/Xilinx" && \
  rm -rf /vivado-installer


ENV XILINXD_LICENSE_FILE /tools/Xilinx/xilinx_ise_vivado.lic
ENV LM_LICENSE_FILE /tools/Xilinx/xilinx_ise_vivado.lic
#COPY xilinx_ise_vivado.lic /tools/Xilinx/xilinx_ise_vivado.lic

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

#w# #make a Vivado user
#w# RUN adduser --disabled-password --gecos '' vivado && \
#w#   usermod -aG sudo vivado && \
#w#   echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#CMD ["/bin/bash", "-l"]
CMD ["vivado"]

