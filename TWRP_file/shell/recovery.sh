#!/system/bin/sh -x






#调用 busybox 的命令
exec_dirname(){
    if [[ $(type "dirname") != *"not found"* ]]; then
        dirname "${@}"
    elif [[ $(busybox --list | grep "dirname") == "dirname" ]]; then
        busybox dirname "${@}"
    else
        echo "dirname 不存在" 1>&2
        return 1
    fi
}


#防止后面步骤出现意外导致在 stop 卡死
set -e
setenforce 0


#检查工作目录
pwddirr="$(exec_dirname ${0})"
exec_dirname_callback=$?
if [[ "${pwddir}" != '' && -f "${pwddir}/TWRP_file/sbin.tar.gz" && -s "${pwddir}/TWRP_file/sbin.tar.gz" ]]; then
    cd "${pwddir}"
    unset "pwddir"
    unset "pwddirr"
    unset "exec_dirname_callback"
elif [[ "${exec_dirname_callback}" == "0" && -f "${pwddirr}/recovery.sh" && -s "${pwddirr}/recovery.sh" ]]; then
    pwddir="$(exec_dirname ${0})"
    cd "${pwddir}"
    cd ".."
    cd ".."
    if [[ -f ."/TWRP_file/sbin.tar.gz" && -s "./TWRP_file/sbin.tar.gz" ]]; then
        unset "pwddir"
        unset "pwddirr"
        unset "exec_dirname_callback"
    else
        echo 'Fa♂Q' 1>&2
        exit 1
    fi
else
    echo "你好像没有安装 busybox\n请安装 busybox 后重试"
    exit 1
fi



echo "正在启动 TWRP"



#挂载部分分区可读写
mount -o remount,rw /
mount -o remount,rw /data
mount -o remount,rw /cache
mount -o remount,rw /system

toolbox mount -o remount,rw /
toolbox mount -o remount,rw /data
toolbox mount -o remount,rw /cache
toolbox mount -o remount,rw /system

if [[ $(busybox --list | grep "mount") == "mount" ]]; then
    busybox mount -o remount,rw /
    busybox mount -o remount,rw /data
    busybox mount -o remount,rw /cache
    busybox mount -o remount,rw /system
fi



#创建 /tmp
if [[ -e "/tmp" ]]; then
    rm -Rf /tmp
fi
mkdir /tmp
chmod 777 /tmp
cp -Rf ./TWRP_file/busybox /tmp/busybox
chmod 777 /tmp/busybox

#引用 /tmp/busybox
alias "tmp-busybox"='/tmp/busybox'


#释放 sbin
mv -f /sbin /sbin_original
mkdir /sbin
chmod 777 /sbin
sleep 0.2
tmp-busybox tar -zxf ./TWRP_file/sbin.tar.gz -C /sbin
#360featureROM2.0特供
cp -f ./TWRP_file/libdirect-coredump.so /sbin
chmod -R 777 /sbin



if [[ -e "/licenes" ]]; then
    rm -Rf /license
fi
cp -Rf ./TWRP_file/license /
chmod 755 /license
chmod 644 /license/*




if [[ -e "/supersu" ]]; then
    rm -Rf /supersu
fi
cp -Rf ./TWRP_file/supersu /
chmod 755 /supersu
chmod 644 /supersu/*



if [[ -e "/etc" ]]; then
    rm -Rf /etc
fi
cp -Rf ./TWRP_file/etc  /
chmod 755 /etc
chmod 644 /etc/*




cp -f ./TWRP_file/.twrps /
chmod 777 /.twrps
cp -Rf ./TWRP_file/twres /
chmod -R 777 /twres
cp -Rf ./TWRP_file/res /
chmod -R 777 /res



cp -Rf ./TWRP_file/rc /tmp/rc
chmod -R 777 /tmp/rc
cp -Rf /tmp/rc/* /
rm -Rf /tmp/rc



#曲线救内置储存不读取
TWRP_sdcard(){
    
    insdcard='/data/media/0'
    
    
    sleep 5.2
    mv -f /sdcard /sdcard_original
    mkdir /sdcard
    chmod 777 /sdcard
    mount -o bind "${insdcard}" /sdcard
    #ln -s "${insdcard}" /sdcard
    #删除变量
    unset "insdcard"
}



#输出log
echolog(){
    echo '----------------------------'
    ps -Z
    echo '----------------------------'
    dmesg
    echo '----------------------------'
    sleep 5.21
    ps -Z
    echo '----------------------------'
    dmesg
}



#解除执行错误保护
set +e


cd '/'

stop
setenforce 0
tmp-busybox killall -9 cploadserver
tmp-busybox killall -9 system_server
tmp-busybox killall -9 vold
tmp-busybox killall -9 sdcard

#防止刷入特定包出现意外
unalias "tmp-busybox"
rm -f /tmp/busybox


echolog &
TWRP_sdcard &

runcon 'u:r:recovery:s0' '/sbin/recovery'
