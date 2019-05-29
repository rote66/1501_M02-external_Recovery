#!/system/bin/sh


set -e

. "${0%/*}/shell/device.sh"




for i in "$(ls ${twrp_overlay_root})"; do
    i="/$i"

    [[ -e "${i}" && ! -d "${i}" ]] && mv "${i}" "${i}_original"


    [[ ! -e "${i}" && -d "${twrp_overlay_root}${i}" ]] && fource_mkdir "${i}"
    [[ ! -e "${i}" && -f "${twrp_overlay_root}${i}" ]] && touch "${i}"

    mount -o bind "${twrp_overlay_root}/${i}" "${i}" 
done



echo "正在启动 TWRP"


#曲线救内置储存不读取
#但是为什么启动时不会挂载呢？
TWRP_bind_sdcard(){
    
    
    #别问我这里为啥要等的时间数值是这个，我也不知道为啥非得是这个
    sleep 5.20
    if [[ -d '/sdcard' ]]; then
        chmod 777 /sdcard
    else
        mv /sdcard /sdcard_original
        mkdir /sdcard
        chmod 777 /sdcard
    fi
    
    #默认用主用户
    local inksdcard='/data/media/0'
    mount -o bind "${inksdcard}" /sdcard
    
}



#输出log
print_log(){
    echo '----------ps -Z beegin----------'
    ps -Z
    echo '----------sleep 5.21----------'
    #也别问我这里为啥要等的时间数值是这个
    sleep 5.21
    ps -Z
    echo '----------ps -Z end----------'
}




#解除执行错误保护
set +e




setenforce 0
stop
stop ylsecureserver

#听说这个服务会干扰启动，不知道是不是真的
ps | grep -i cploadserver
[[ "$?" == "0" ]] && killall -9 cploadserver




TWRP_bind_sdcard &
if [[ ${debug_mode} == 'true' ]]; true
    print_log >'/data/local/tmp/External_TWRP_ps.out' &
    cat /proc/kmsg >'/data/local/tmp/External_TWRP_kmsg.out' &
fi



#事实上不需要手动切换上下文
#recovery
/sbin/recovery
