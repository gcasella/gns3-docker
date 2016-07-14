FROM ubuntu:latest
MAINTAINER Gian-Luca Casella <gcasella@casellanetworks.ca>
ENV container docker
ENV HOSTNAME gns3-docker

#Create GNS3 Users for Service;
RUN mkdir -p /opt/gns3/.log/ && mkdir /opt/gns3/.config/ && mkdir /opt/gns3/images/ && mkdir /opt/gns3/symbols/ && \
	mkdir /opt/gns3/configs/ && mkdir /opt/gns3/projects/ && mkdir /opt/gns3/.license/ && \
	mkdir /opt/gns3/.pid/  

#Perform system update and install necessary packages for GNS3 Server 1.5+
COPY gns3-xenial-ppa.list /etc/apt/sources.list.d/
RUN	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A2E3EF7B && dpkg --add-architecture i386
RUN	apt-get update && apt-get upgrade -y

RUN	apt-get install -y curl software-properties-common gns3-server vde2 uml-utilities open-vm-tools dynamips iouyap ubridge x11vnc xvfb gns3-iou 
RUN	apt-get install -y python3-pip python3-dev python3-setuptools python3-netifaces


RUN	pip3 install pip --upgrade && \
	pip3 install setuptools --upgrade
	
#Install Docker v1.10.3 binaries.

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.10.3
ENV DOCKER_SHA256 d0df512afa109006a450f41873634951e19ddabf8c7bd419caeb5a526032d86d

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
        && echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
        && chmod +x /usr/local/bin/docker



#Create Service File to start GNS3 server on-boot
#COPY vpcs /usr/local/bin/vpcs
COPY gns3_server.conf /opt/gns3/.config/gns3_server.conf
COPY iourc /opt/gns3/.license/.iourc
COPY hostid.sh /tmp/hostid.sh
COPY gns3.sh /etc/init.d/gns3
RUN chmod +x /tmp/hostid.sh && /tmp/hostid.sh 030a035b && chmod +x /etc/init.d/gns3 

RUN echo 'root:gns3' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#CLEAN UP 
RUN	apt-get purge -y --force-yes vim-common  \
	fonts-ubuntu-font-family-console  \
	linux-headers-generic  \ 
	linux-headers-virtual  \
	vim-runtime  \
	screen  \
	tmux  \
	memtest86+  \
	usbutils  \
	linux-firmware  \
	wpasupplicant  \
	wireless-tools  \
	wireless-regdb  \
	ppp  \
	w3m  \
	python2.7-minimal  \
	man-db  \
	sgml-base  \
	mtr-tiny  \
	lshw  \
	geoip-database  \
	groff-base  \
	fuse  \
	update-manager-core  \
	ntpdate  \
	apport  \
	bc  \
	aptitude  \
	libtext-iconv-perl  \
	libpython2.7-minimal  \
	libapparmor-perl  \
	libtext-charwidth-perl  \
	unattended-upgrades  \
	ntfs-3g  \
	manpages  \
	krb5-locales  \
	git  \
	cmake-data  \
	cpp-4.9  \
	language-pack-en  \
	language-pack-gnome-en-base

# Purge old kernels
RUN dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge

RUN dpkg -l 'linux-headers-*' |grep '^ii'|sed 's/^ii[ ]*//'|cut -f1 -d' '| xargs apt-get -y purge
RUN dpkg -l 'linux-image-extra-*' |grep '^ii'|sed 's/^ii[ ]*//'|cut -f1 -d' '| xargs apt-get -y purge


# Purge locale
RUN rm -Rf /usr/share/locale/*
RUN locale-gen --purge --lang en_US

RUN apt-get -y autoremove
RUN apt-get -y clean

RUN rm -fr /var/lib/apt/lists/*
RUN rm -fr /var/cache/apt/*
RUN rm -fr /var/cache/debconf/*
RUN rm -fr /var/cache/man/*
RUN rm -Rf /var/log/installer/*
RUN rm -Rf /usr/share/doc
RUN rm -Rf /var/lib/docker/devicemapper

RUN rm -rf /tmp/*

EXPOSE 3080
WORKDIR /opt/gns3/
# Load script to start GNS3 and Docker Daemon at the same time
ENTRYPOINT ["/etc/init.d/gns3"]
