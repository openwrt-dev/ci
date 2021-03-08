#!/bin/bash -e

copy_binaries() {
  local sub_path=$(echo ${CONFIG_URL##*/} | tr '-' '/')
  mkdir binaries
  cp -v openwrt/bin/targets/$sub_path/* binaries/ 2>/dev/null || true
}

create_tarball() {
  local arch=${CONFIG_URL##*/}
  cd binaries
  tar -zcvf ../${arch}.tar.gz *
  cd ..
  rm -r binaries
}

copy_binaries
create_tarball
