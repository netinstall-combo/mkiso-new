#!/bin/bash
function build(){
  :
}

function package(){
    mkdir -p $DESTDIR/initrd/etc/udhcpc
    install $DATA/init.sh $DESTDIR/initrd/init
    install $DATA/udhcpc.script $DESTDIR/initrd/etc/udhcpc/default.script
    install $DESTDIR/busybox $DESTDIR/initrd/
    # generate initramfs
    cur=$PWD
    cd $DESTDIR/initrd/
    find . | cpio -R root:root -H newc -o > $DESTDIR/initramfs
    cd $cur
    # build iso image
    mkdir -p $DESTDIR/iso/boot/grub
    install $DESTDIR/linux $DESTDIR/iso/linux
    install $DESTDIR/initramfs $DESTDIR/iso/initrd
    echo "linux /linux quiet" > $DESTDIR/iso/boot/grub/grub.cfg
    echo "initrd /initrd" >> $DESTDIR/iso/boot/grub/grub.cfg
    echo "boot" >> $DESTDIR/iso/boot/grub/grub.cfg
    grub-mkrescue -o $DESTDIR/netinstall-combo.iso --fonts="" --install-modules="linux normal fat all_video" --compress=xz --locales="" $DESTDIR/iso
    exit 1
}

