#!/bin/bash -e

get_sources() {
  git clone https://github.com/openwrt-dev/openwrt.git --single-branch -b ${GITHUB_REF##*/}
}

build_firmware() {
  cd openwrt

  ./scripts/feeds update -a
  ./scripts/feeds install -a

  wget $CONFIG_URL -O .config
  [ "$VERBOSE_LOG" != 1 ] && make -j$(nproc) V=w || make -j1 V=sc

  cd ..
}

get_sources
build_firmware
