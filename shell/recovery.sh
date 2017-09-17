#!/system/bin/sh
echo "请在5秒内关闭你输入法弹窗"
sleep 5
echo "开始运行Recovery"
mount -o remount /;
mount -o remount /data;
mount -o remount /cache;
mount -o rw,remount /system 
mount -o rw,remount /
#准备ramdisk
#rm -rf /sbin
#cp -Rf /sdcard/TWRP/sbin /
#chmod 755 /sbin
#chmod 750 /sbin/*
rm -rf /tmp
mkdir /tmp
cp -rf /sdcard/TWRP/busybox /tmp/busybox
chmod 777 /tmp/busybox
rm -rf /sbin
mkdir /sbin
#for 360os2.0
cp -Rf /sdcard/TWRP/libdirect-coredump.so /sbin
chmod 0777 /sbin/libdirect-coredump.so
#Extra
/tmp/busybox tar -zxvf /sdcard/TWRP/sbin.tar.gz -C /sbin
#准备完毕
#拓展
#rm -rf /tmp
#mkdir /tmp
#chmod 755 /tmp
#cp -rf /sdcard/TWRP/busybox /tmp
#chmod 777 /tmp/busybox
#mount -t tmpfs tmpfs /tmp
#mount -o rw,remount /
#mount -o rw,remount /tmp
rm -rf /license
cp -Rf /sdcard/TWRP/license /
chmod 755 /license
chmod 644 /license/*
rm -rf /supersu
cp -Rf /sdcard/TWRP/supersu /
chmod 755 /supersu
chmod 644 /supersu/*
#准备分区表
rm -rf /etc
cp -rf /sdcard/TWRP/etc  /
chmod 755 /etc
chmod 644 /etc/mke2fs.conf
chmod 644 /etc/recovery.fstab
chmod 644 /etc/twrp.fstab
#准备完毕
cp -rf /sdcard/TWRP/twres /
chmod -R 777 /twres
#准备资源文件
cp -rf /sdcard/TWRP/res /
chmod -R 777 /res
#准备完毕
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
