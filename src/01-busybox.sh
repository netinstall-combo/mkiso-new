#!/bin/bash
_bver="1.37.0"
export CFLAGS="-Wno-all -Os -s"
export CC=musl-gcc
function build(){
    [ -f busybox_${_bver}.orig.tar.bz2 ] || wget http://deb.debian.org/debian/pool/main/b/busybox/busybox_${_bver}.orig.tar.bz2
    tar -xf busybox_${_bver}.orig.tar.bz2
    make defconfig -C busybox-${_bver}
    sed -i "s|.*CONFIG_STATIC.*|CONFIG_STATIC=y|" busybox-${_bver}/.config
    sed -i "s|CONFIG_TC=.*|# CONFIG_TC is not set|" busybox-${_bver}/.config
    yes "" | make oldconfig -j`nproc` -C busybox-${_bver}
    echo 'CONFIG_CROSS_COMPILER_PREFIX="musl-"' >> busybox-${_bver}/.config
    make -C busybox-${_bver}
}

function package(){
    install busybox-${_bver}/busybox $DESTDIR/busybox
}