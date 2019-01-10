#!/bin/bash -e

setup_environment() {
  ccache -M 30G
}

get_sources() {
  git clone --single-branch -b openwrt-18.06 https://github.com/openwrt-dev/openwrt.git
}

restore_cache() {
  if [ -d "openwrt-dl" ]; then
    mv openwrt-dl openwrt/dl
  fi
}

build_firmware() {
  pushd openwrt

  ./scripts/feeds update -a
  ./scripts/feeds install -a

  wget -O .config $OPENWRT_CONFIG_URL_AR71XX_GENERIC
  make -j4 V=w
  rm .config

  wget -O .config $OPENWRT_CONFIG_URL_AR71XX_TINY
  make -j4 V=w
  rm .config

  wget -O .config $OPENWRT_CONFIG_URL_RAMIPS_MT7620
  make -j4 V=w
  rm .config

  wget -O .config $OPENWRT_CONFIG_URL_X86_64
  make -j4 V=w
  rm .config

  popd
}

update_cache() {
  if [ -d "openwrt/dl" ]; then
    mv openwrt/dl openwrt-dl
  fi
}

setup_environment
get_sources
restore_cache
build_firmware
update_cache
