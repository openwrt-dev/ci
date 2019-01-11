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

  curl -kLs $OPENWRT_CONFIG_URL > .config
  make -j4 V=w

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
