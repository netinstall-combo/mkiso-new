#!/busybox ash
# install yourself
/busybox clear
/busybox mkdir /bin
/busybox --install -s /bin
# mount directories
mkdir -p /dev /sys /proc /run /tmp
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys
# busybox networking
for dev in $(ls /sys/class/net) ; do
    echo "Network enable $dev"
    ip link set up dev $dev
    udhcpc -i $dev -s /etc/udhcpc/default.script 2>>/logs >>/logs &
done
# spawn shell
exec setsid cttyhack /bin/sh