#!/system/bin/sh




set -e
. "${0%/*}/utils.sh"
setenforce 0



if [[ ${1} == '--debug' ]]; then
    export debug_mode=true
    shift
fi




#检查 TWRP 文件
check_twrp_file(){
    if [[ -s "${1}/TWRP_ramdisk.tar.gz" ]]; then
        export TWRP_FILE_PATH="${1}"
    fi
}

check_twrp_file "${TWRP_FILE_PATH}"
check_twrp_file "${0%/*/*}"
check_twrp_file "${1%/*}"
[[ -z ${TWRP_FILE_PATH} ]] && echo '文件不存在' >&2 && exit 1



echo "正在释放 TWRP"



#挂载一些分区可读写
mount -o remount,rw /
mount -o remount,rw /data
mount -o remount,rw /cache
mount -o remount,rw /system


#创建 /tmp
force_mkdir /tmp
mount -t tmpfs -o tmpfs /tmp
chmod -R 770 /tmp



#外挂式 TWRP 文件与临时 busybox 放在这里
export twrp_overlay_root='/tmp-twrp'
force_mkdir "${twrp_overlay_root}"
mount -t tmpfs -o size=64m,rw tmpfs "${twrp_overlay_root}"
cp -f "${TWRP_FILE_PATH}/busybox" "${twrp_overlay_root}/busybox"
chmod -R 755 "${twrp_overlay_root}"
/tmp-twrp/busybox tar -zxf "${TWRP_FILE_PATH}/TWRP_ramdisk.tar.gz" -C "${twrp_overlay_root}"



[[ ${debug_mode} == 'true' ]] && exec sh -x "${TWRP_FILE_PATH}/shell/start_recovery.sh" ||
    exec sh "${TWRP_FILE_PATH}/shell/start_recovery.sh"
