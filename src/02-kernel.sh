#!/bin/bash

_kver="6.17"

export CFLAGS="-O3 -s"

function build(){
    # fetch kernel
    [ -f linux-${_kver}.tar.xz ] || wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${_kver}.tar.xz
    [ -d linux-${_kver} ] || tar -xf linux-${_kver}.tar.xz
    # build kernel
    cd linux-${_kver}
    make defconfig
    {
        find ./drivers/net -iname Kconfig -exec grep "config " {} \;
        find ./drivers/scsi -iname Kconfig -exec grep "config " {} \;
        find ./drivers/mmc -iname Kconfig -exec grep "config " {} \;
        find ./drivers/usb -iname Kconfig -exec grep "config " {} \;
        find ./drivers/virtio -iname Kconfig -exec grep "config " {} \;
        find ./fs -iname Kconfig -exec grep "config " {} \;
    } | cut -f 2 -d " " | while read line ; do
         ./scripts/config --enable CONFIG_$config
    done
    {
        find ./drivers/gpu -iname Kconfig -exec grep "config " {} \;
    } | cut -f 2 -d " " | while read line ; do
         ./scripts/config --disable CONFIG_$config
    done
    cd ..
    yes "" | make oldconfig -C linux-${_kver}
    make bzImage -j`nproc` -C linux-${_kver}
}

function package(){
    install linux-${_kver}/arch/x86/boot/bzImage $DESTDIR/linux
}