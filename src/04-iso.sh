#!/bin/bash
function build(){
  :
}

function package(){
    # build iso image
    mkdir -p $DESTDIR/iso/boot/grub
    install $DESTDIR/linux $DESTDIR/iso/linux
    install $DESTDIR/initramfs $DESTDIR/iso/initrd
    echo "insmod all_video" > $DESTDIR/iso/boot/grub/grub.cfg
    echo "linux /linux quiet console=ttyS0" > $DESTDIR/iso/boot/grub/grub.cfg
    echo "initrd /initrd" >> $DESTDIR/iso/boot/grub/grub.cfg
    echo "boot" >> $DESTDIR/iso/boot/grub/grub.cfg
    grub-mkrescue -o $DESTDIR/netinstall-combo.iso --fonts="" --install-modules="linux normal fat all_video" --compress=xz --locales="" $DESTDIR/iso
    exit 1
}

