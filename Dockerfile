FROM debian:bookworm AS fai-mk-configspace
RUN apt-get update && apt-get install -y wget
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
RUN echo "" >> /etc/apt/sources.list
RUN apt update && apt-get install -y fai-quickstart apt-cacher-ng
RUN fai-mk-configspace
# Thanks to https://raw.githubusercontent.com/ricardobranco777/docker-fai/master/Dockerfile

FROM python:3.11.6-slim-bookworm
COPY --from=fai-mk-configspace /srv/fai/config /fai-mk-configspace
RUN apt-get update && apt-get install -y wget curl && apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin
# RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg
# RUN cp fai-project.gpg /etc/apt/trusted.gpg.d/
# RUN echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list
# RUN echo "" >> /etc/apt/sources.list

# # Install packages
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		wait-for-it binutils binutils-common binutils-x86-64-linux-gnu debconf-utils debootstrap \
		dirmngr dmsetup file gnupg \
		gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server gpgconf && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		gpgsm iproute2 isc-dhcp-server keyutils libarchive13 libassuan0 libbinutils \
		libbpf1 libbsd0 libburn4 libcap2-bin libctf-nobfd0 libctf0 && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		libdevmapper1.02.1 libelf1 libevent-2.1-7 libevent-core-2.1-7 \
		libfile-lchown-perl libgdbm-compat4 libgpgme11 libgprofng0 libicu72 && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		libisoburn1 libisofs6 libjansson4 libjte2 libksba8 liblzo2-2 libmagic-mgc \
		libmagic1 libmnl0 libnfsidmap1 libnpth0 libperl5.36 libproc2-0 \
		libpython3-stdlib libpython3.11-minimal libpython3.11-stdlib libwrap0 \
		libxml2 libxtables12 media-types nfs-common nfs-kernel-server openbsd-inetd \
		perl perl-modules-5.36 pinentry-curses procps python3 python3-minimal \
		python3.11 python3.11-minimal reprepro rpcbind sensible-utils squashfs-tools \
		tcpd tftpd-hpa ucf update-inetd xorriso xz-utils zstd && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		fai-client fai-doc fai-server && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin
RUN	apt-get update && \
	apt-get install --no-install-recommends -y \
		fai-quickstart && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN	apt-get update && \
	apt-get install --no-install-recommends -y \
		apt-cacher-ng && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		lsb-release && \
	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

# Configuration
RUN	echo "deb http://fai-project.org/download bookworm koeln" >> /etc/apt/sources.list
RUN	echo "deb http://deb.debian.org/debian bookworm main non-free-firmware" >> /etc/apt/sources.list
RUN	echo "deb-src http://deb.debian.org/debian bookworm main non-free-firmware" >> /etc/apt/sources.list

RUN	echo "deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware" >> /etc/apt/sources.list
RUN	echo "deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware" >> /etc/apt/sources.list

RUN	echo "deb http://deb.debian.org/debian bookworm-updates main non-free-firmware" >> /etc/apt/sources.list
RUN	echo "deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware" >> /etc/apt/sources.list
RUN	echo "http://mirror.netcologne.de/debian bookworm main contrib non-free non-free-firmware" >> /etc/apt/sources.list
RUN cp /etc/apt/sources.list /etc/fai/apt/
#RUN rm /etc/apt/sources.list.d/debian.sources && \
#	echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs) 				main" > /etc/apt/sources.list && \
#	echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs)-updates 		main" >> /etc/apt/sources.list && \
#	echo "deb http://127.0.0.1:9999/debian-security/ 	$(lsb_release -cs)-security 	main" >> /etc/apt/sources.list && \
#	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] http://127.0.0.1:9999/mirrors.cloud.tencent.com/docker-ce/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
#	echo "deb http://fai-project.org/download bookworm koeln" >> /etc/apt/sources.list && \
#	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
#	sed -ri 's/^Remap-(gentoo|sfnet):/#&/' /etc/apt-cacher-ng/acng.conf && \
#	echo "http://deb.debian.org/debian" > /etc/apt-cacher-ng/backends_debian && \
#	cp /etc/apt/sources.list /etc/fai/apt/
# 
# http://mirrors.cloud.tencent.com/docker-ce/linux/debian/dists/bookworm/stable/
# http://mirrors.huaweicloud.com/docker-ce/linux/debian/dists/bookworm/stable/

ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /etc/apt/keyrings/
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --yes --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN wget -O fai-project.gpg https://fai-project.org/download/2BF8D9FE074BCDE4.gpg && \
	cp fai-project.gpg /etc/apt/trusted.gpg.d/ && \
	echo "deb http://fai-project.org/download bookworm koeln" > /etc/apt/sources.list.d/fai.list && \
	echo "" >> /etc/apt/sources.list
# RUN /etc/init.d/apt-cacher-ng start && apt update && apt-get install -y --no-install-recommends --download-only pxelinux python3 python3-minimal python3-ntp python3.11 python3.11-minimal  rdate readline-common reiserfsprogs rpcbind rsync runit-helper sed  sensible-utils sgml-base shared-mime-info shim-helpers-amd64-signed  shim-signed shim-signed-common shim-unsigned smartmontools ssh startpar  syslinux-common syslinux-efi sysv-rc sysvinit-core sysvinit-utils tar  thin-provisioning-tools ucf udev udns-utils usb.ids usbutils usrmerge  uuid-runtime xauth xdg-user-dirs xfsdump xfsprogs xkb-data xml-core xz-utils  zile zlib1g zstd && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin && rm -rf /var/lib/apt/lists/* && apt-get clean
# RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs) 				main" > /etc/apt/sources.list
# RUN echo "deb http://127.0.0.1:9999/debian/ 			$(lsb_release -cs)-updates 		main" >> /etc/apt/sources.list
# RUN echo "deb http://127.0.0.1:9999/debian-security/ 	$(lsb_release -cs)-security 	main" >> /etc/apt/sources.list

RUN /etc/init.d/apt-cacher-ng start && apt update && \
 	apt-get install --no-install-recommends -y apt-cacher-ng \
 		apt-transport-https \
 		aptitude \
 		binutils \
 		bzip2 \
 		ca-certificates \
 		fai-quickstart \
 		isc-dhcp-server nfs-kernel-server openbsd-inetd openssh-server tcpd tftpd-hpa update-inetd \
 		debian-archive-keyring \
 		gawk \
 		grub-pc-bin \
 		less \
 		liblz4-tool \
 		memtest86+ \
 		openssh-client \
 		patch \
 		reprepro \
 		tzdata \
 		vim \
 		wget \
 		xorriso \
 		xz-utils && \
 	apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin

RUN /etc/init.d/apt-cacher-ng start && apt update && apt-get install -y --no-install-recommends --download-only btrfs-progs ca-certificates console-common console-data cryptsetup cryptsetup-bin curl dialog dmeventd dosfstools dracut dump efibootmgr && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN /etc/init.d/apt-cacher-ng start && apt update && apt-get install -y --no-install-recommends logsave lsb-release dosfstools media-types dnsmasq mtools netbase nfs-common nfs-kernel-server openbsd-inetd openssh-client openssl passwd   binutils binutils-common binutils-x86-64-linux-gnu build-essential bzip2 cpp  && rm -rf /var/cache/apt/archives/* && rm -rf /var/cache/apt/*.bin && rm -rf /var/lib/apt/lists/* && apt-get clean

RUN echo "" > /var/log/apt-cacher-ng/apt-cacher.log
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d
