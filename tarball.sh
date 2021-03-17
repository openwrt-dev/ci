#!/bin/bash -e
set -o pipefail

copy_binaries() {
  local sub_path=$(echo $BUILD_ARCH | tr '-' '/')
  mkdir binaries
  cp -v openwrt/bin/targets/$sub_path/* binaries/ 2>/dev/null || true
}

create_tarball() {
  local arch=$BUILD_ARCH
  cd binaries
  tar -zcvf ../${arch}.tar.gz *
  cd ..
  rm -r binaries
}

copy_binaries
create_tarball
