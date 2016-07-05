FROM fedora:24
MAINTAINER Gian-Luca Casella <gcasella@casellanetworks.ca>
ENV container docker
ENV HOSTNAME gns3-docker

#Create GNS3 Users for Service;
RUN mkdir -p /opt/gns3/.log/ && mkdir /opt/gns3/.config/ && mkdir /opt/gns3/images/ && mkdir /opt/gns3/symbols/ && \
	mkdir /opt/gns3/configs/ && mkdir /opt/gns3/projects/ && mkdir /opt/gns3/.license/ && \
	mkdir /opt/gns3/.pid/ && useradd -M -r -d /opt/gns3/ --user-group -s /sbin/nologin gns3 

#Perform system update and install necessary packages for GNS3 Server 1.5+
RUN dnf --setopt=deltarpm=false update -y && dnf --best --allowerasing --setopt=deltarpm=false install redhat-rpm-config \
	openssl-libs.i686 \
	openssl-devel.i686 \
	openssl-devel \
	cmake \
	iniparser \
	iniparser-devel \
	python3-devel \
	git \
	uuid \
	uuid-devel \
	procps-ng \
	elfutils-libelf-devel \
	net-tools \
	iputils \
	wget \
	qemu \
	qemu-kvm \
	libpcap libpcap-devel -y && \
	dnf --setopt=deltarpm=false --best --allowerasing group install "C Development Tools and Libraries" -y && \
	dnf --setopt=deltarpm=false --best --allowerasing group install "Development Tools" -y && \

	#Download and install source code from github fror dynamips, ubridge, iouyap
	mkdir /usr/src/gns3/ && cd /usr/src/gns3/ && git clone https://github.com/gns3/dynamips && git clone https://github.com/gns3/ubridge && git clone https://github.com/gns3/iouyap && \
	cd /usr/src/gns3/dynamips && mkdir build/ && cd build/ && cmake .. && make && make install && whereis dynamips && rm -rf /usr/src/gns3/dynamips && \
	cd /usr/src/gns3/iouyap && make && make install && whereis iouyap && rm -rf /usr/src/gns3/iouyap && \
	cd /usr/src/gns3/ubridge && make && make install && whereis ubridge && rm -rf /usr/src/gns3/ubridge && \
	cd ~/ && \

	pip3 install pip --upgrade && \
	pip3 install setuptools --upgrade && \
	pip3 install gns3-server --upgrade && \

	dnf clean all


#Create Service File to start GNS3 server on-boot
COPY vpcs /usr/local/bin/vpcs
COPY gns3_server.conf /opt/gns3/.config/gns3_server.conf
COPY iourc /opt/gns3/.license/.iourc
COPY hostid.sh /tmp/hostid.sh
COPY gns3.sh /etc/init.d/gns3
RUN setcap cap_net_raw,cap_net_admin+p /usr/bin/ping && chmod +x /usr/local/bin/vpcs && chown -R gns3:gns3 /opt/gns3/ && usermod -aG kvm gns3 && \
	chmod +x /tmp/hostid.sh && /tmp/hostid.sh 030a035b && chmod +x /etc/init.d/gns3 && rm -rf /tmp/hostid.sh

EXPOSE 3080

WORKDIR /opt/gns3/
ENTRYPOINT ["/etc/init.d/gns3","start"]
