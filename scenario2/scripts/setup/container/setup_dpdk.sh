#!/bin/bash
# Install DPDK on the containers

# exit on error
set -e
# log every command
set -x

#Installing required information
DEBIAN_FRONTEND=noninteractive apt-get update --allow-releaseinfo-change

apt-get install -y build-essential libpcap-dev   \
	libnet1-dev libyaml-0-2 libyaml-dev pkg-config zlib1g zlib1g-dev \
	libcap-ng-dev libcap-ng0 make libmagic-dev         \
	libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev \
	python3-yaml rustc cargo libpcre2-dev meson ninja-build \
	python3-pyelftools libjansson-dev cbindgen intel-cmt-cat

cd /root
git clone https://github.com/gallenmu/dpdk-1 /root/dpdk-21.11
cd /root/dpdk-21.11

meson -Ddisable_drivers=gpu/*,baseband/*,event/*,vdpa/*,regex/*,compress/*,crypto/*,raw/*,dma/cnxk,dma/dpaa,dma/hisilicon,mempool/cnxk,mempool/dpaa,mempool/dpaa2,mempool/octeontx,mempool/octeontx2,net/a*,net/b*,net/c*,net/d*,net/ena,net/enetc,net/enetfec,net/enic,net/f*,net/h*,net/k*,net/l*,net/m*,net/n*,net/o*,net/p*,net/q*,net/s*,net/t*,net/v*,common/dpaax,common/cnxk,common/octeontx,common/octeontx2,common/sfc_efx,common/cpt -Dexamples=l3fwd,l2fwd,l2fwd-cat build
cd /root/dpdk-21.11/build
ninja install

sysctl vm.stat_interval=3600
sysctl -w kernel.watchdog=0
