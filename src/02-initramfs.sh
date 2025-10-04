#!/bin/bash
function build(){
  :
}
function package(){
    mkdir -p $DESTDIR/initrd/etc/udhcpc
    cp -prvf $DATA/* $DESTDIR/initrd/
    install $DESTDIR/busybox $DESTDIR/initrd/
    # generate initramfs
    cd $DESTDIR/initrd/
    find . | cpio -R root:root -H newc -o > $DESTDIR/initramfs
}
