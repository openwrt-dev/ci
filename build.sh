#!/bin/bash -e

get_sources() {
  git clone --single-branch -b $OPENWRT_BRANCH https://github.com/openwrt-dev/openwrt.git
}

build_firmware() {
  cd openwrt

  ./scripts/feeds update -a
  ./scripts/feeds install -a

  curl -sSL $OPENWRT_CONFIG_URL -o .config
  make -j4 V=w

  cd ..
}

get_sources
build_firmware
