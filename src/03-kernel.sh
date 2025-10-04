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
        find ./drivers/gpu -iname Kconfig -exec grep "config " {} \;
        find ./drivers/virtio -iname Kconfig -exec grep "config " {} \;
        find ./fs -iname Kconfig -exec grep "config " {} \;
    } | cut -f 2 -d " " | while read line ; do
         echo "CONFIG_$line"
         ./scripts/config --enable CONFIG_$line
    done
    ./scripts/config --enable CONFIG_DRM_EFIDRM
    ./scripts/config --enable CONFIG_DRM_SIMPLEDRM
    ./scripts/config --enable CONFIG_DRM_VESADRM
    grep "CONFIG_[A-Z0-9]*_FS" .config  | cut -f2 -d" " | while read cfg ; do
        ./scripts/config --enable $cfg
    done
    ./scripts/config --disable CONFIG_DRM_I915
    ./scripts/config --disable CONFIG_DRM_NOUVEAU
    ./scripts/config --disable CONFIG_DRM_AMDGPU
    cd ..
    yes "" | make bzImage -j`nproc` -C linux-${_kver}
}

function package(){
    install linux-${_kver}/arch/x86/boot/bzImage $DESTDIR/linux
}