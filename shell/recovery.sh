#!/system/bin/sh
echo "请在5秒内关闭你输入法弹窗"
sleep 5
echo "开始运行Recovery"
mount -o remount /;
mount -o remount /data;
mount -o remount /cache;
mount -o rw,remount /system 
mount -o rw,remount /
rm -rf /tmp
mkdir /tmp
cp -rf /sdcard/TWRP/busybox /tmp/busybox
chmod 777 /tmp/busybox
rm -rf /sbin
mkdir /sbin
cp -Rf /sdcard/TWRP/libdirect-coredump.so /sbin
chmod 0777 /sbin/libdirect-coredump.so
/tmp/busybox tar -zxvf /sdcard/TWRP/sbin.tar.gz -C /sbin
rm -rf /license
cp -Rf /sdcard/TWRP/license /
chmod 755 /license
chmod 644 /license/*
rm -rf /supersu
cp -Rf /sdcard/TWRP/supersu /
chmod 755 /supersu
chmod 644 /supersu/*
rm -rf /etc
cp -rf /sdcard/TWRP/etc  /
chmod 755 /etc
chmod 644 /etc/mke2fs.conf
chmod 644 /etc/recovery.fstab
chmod 644 /etc/twrp.fstab
cp -rf /sdcard/TWRP/twres /
chmod -R 777 /twres
cp -rf /sdcard/TWRP/res /
chmod -R 777 /res
cp -Rf /sdcard/TWRP/rc /data/shell/rc
chmod -R 777 /data/shell/rc
cp -Rf /data/shell/rc/* /
rm -rf /data/shell/rc
stop
setenforce 0
busybox killall cploadserver
busybox killall system_server
runcon u:r:recovery:s0
/sbin/recovery
rm -rf /data/shell
