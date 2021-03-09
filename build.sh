#!/bin/bash -e

[ "$VERBOSE_LOG" == 1 ] && set -x

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

restore_cache() {
  if [ -d "openwrt-dl" ]; then
    mv -v openwrt-dl openwrt/dl
  fi
}

update_cache() {
  if [ -d "openwrt/dl" ]; then
    mv -v openwrt/dl openwrt-dl
  fi
}

get_sources
restore_cache
build_firmware
update_cache
