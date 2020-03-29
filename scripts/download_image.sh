#!/bin/sh

set -ex

test ! -d images && mkdir images
cd images

if [ ! -f latest.qcow2 ]; then
  coreos-installer download \
    --stream stable \
    --platform qemu \
    --format qcow2.xz \
    --decompress

  latest_image=$(ls -tc *.qcow2 | head -n1)
  ln -s $latest_image latest.qcow2
fi
