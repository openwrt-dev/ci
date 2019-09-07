#!/bin/bash -e

TARGET=$(basename $OPENWRT_CONFIG_URL | cut -d "-" -f 1)
SUBTARGET=$(basename $OPENWRT_CONFIG_URL | cut -d "-" -f 2)

prepare() {
  local api_url="https://api.github.com/repos/tcnksm/ghr/releases/latest"
  local download_tag=$(curl -sSL $api_url | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
  local download_url=$(curl -sSL $api_url | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

  curl -sSL $download_url | sudo -E tar -zxf - -C /usr/local/bin/ ghr_${download_tag}_linux_amd64/ghr --strip-components 1
}

release() {
  mkdir release
  cp openwrt/bin/targets/$TARGET/$SUBTARGET/config.seed release/ || true
  cp openwrt/bin/targets/$TARGET/$SUBTARGET/sha256sums release/ || true
  cp openwrt/bin/targets/$TARGET/$SUBTARGET/*factory.bin release/ || true
  cp openwrt/bin/targets/$TARGET/$SUBTARGET/*sysupgrade.bin release/ || true
  cp openwrt/bin/targets/$TARGET/$SUBTARGET/*combined*.img.gz release/ || true
}

deploy() {
  local release_version=$OPENWRT_BRANCH-$TARGET-$SUBTARGET

  ghr -t $GITHUB_TOKEN \
    -u $CIRCLE_PROJECT_USERNAME \
    -r $CIRCLE_PROJECT_REPONAME \
    -c $CIRCLE_SHA1 \
    -n $release_version \
    -delete \
    $release_version release
}

prepare
release
deploy
