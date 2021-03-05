FROM ubuntu18
LABEL maintainer "ittou <VYG07066@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ARG SDK_VER
ARG IDE_VER
ARG IP
ARG URIS=smb://${IP}/Share/MCUXPRESSO${IDE_VER}/
RUN \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install sudo && \
  apt-get -y -qq --no-install-recommends install \
          locales && locale-gen en_US.UTF-8 && \
  apt-get -y -qq --no-install-recommends install \
          whiptail \
          build-essential \
          bzip2 \
          libswt-gtk-3-jni \
          libswt-gtk-3-java \
          libwebkit2gtk-4.0-37 \
          libwebkitgtk-1.0-0 \
          libusb-1.0-0-dev \
          dfu-util \
          wget \
          usbutils \
          net-tools \
          unzip \
          udev \
          smbclient && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y -qq --no-install-recommends install \
          libncurses5:i386 && \
  apt-get autoclean && \
  apt-get autoremove && \
  mkdir /MCU-INSTALLER && \
  smbget -a ${URIS}mcuxpressoide-${IDE_VER}.x86_64.deb.bin -o /MCU-INSTALLER/mcuxpressoide-${IDE_VER}.x86_64.deb.bin && \
  /MCU-INSTALLER/mcuxpressoide-${IDE_VER}.x86_64.deb.bin --noexec --target /MCU-INSTALLER/tmp && \
  cd /MCU-INSTALLER/tmp && \
  dpkg -i --force-depends JLink_Linux_x86_64.deb &&\
  dpkg --unpack mcuxpressoide-${IDE_VER}.x86_64.deb &&\
  rm /var/lib/dpkg/info/mcuxpressoide.postinst -f &&\
  dpkg --configure mcuxpressoide &&\
  apt-get install -yf &&\
  mkdir -p /usr/share/NXPLPCXpresso &&\
  chmod a+w /usr/share/NXPLPCXpresso &&\
  ln -s /usr/local/mcuxpressoide-${IDE_VER} /usr/local/mcuxpressoide &&\
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /MCU-INSTALLER
ENV IDE_PATH /usr/local/mcuxpressoide/ide
ENV TOOLCHAIN_PATH ${IDE_PATH}/tools/bin
ENV PATH $IDE_PATH:$TOOLCHAIN_PATH:$PATH
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]

