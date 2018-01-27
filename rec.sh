#!/system/bin/sh




###########################################
# BootScript V3.01 for 1501_M02   #
# Mod by 小w                            #
# 微小的工作 by 滑稽Pro           #
###########################################
# $ver: V11                                #
###########################################
##########################################
#Check for root                          #
##########################################




#调用可能是 busybox 的命令
exec_cut(){
    if [[ $(type "cut") != *"not found"* ]]; then
        cut "${@}"
    elif [[ $(busybox --list | grep "cut") == "cut" ]]; then
        busybox cut "${@}"
    else
        echo "cut 不存在" 1>&2
        return 1
    fi
}
exec_killall(){
    if [[ $(type "killall") != *"not found"* ]]; then
        killall "${@}"
    elif [[ $(busybox --list | grep "killall") == "killall" ]]; then
        busybox killall "${@}"
    else
        echo "killall 不存在" 1>&2
        return 1
    fi
}
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





#判断是否以root进程执行
if [[ "${USER_ID}" == "" ]]; then
    if [[ "${USER}" == "root" ]]; then
        USER_ID="0"
    elif [[ $(id | grep -E '^uid=0(root) gid=0(root).*$') == *"uid=0(root) gid=0(root)"* ]]; then
        USER_ID="0"
    elif [[ $(id | exec_cut -b 5) = "0" ]]; then
        USER_ID="0"
    fi
fi
if [[ "${USER_ID}" == "0" ]]; then 
suversion="$(su -v)"
    if [[ "${suversion}" == *"360"* ]]; then
        echo "注意：用 360root 启动外挂式 TWRP 刷入 SuperSU 时建议准备好完整的卡刷包并提前刷入\n"
    elif [[ "${suversion}" == *"king"* ]]; then
        echo "按照惯例，多数外挂式 TWRP 在 Kingroot 为 su 提供方时很有可能出现一些神奇的卡死问题\n" 1>&2
    elif [[ "${suversion}" == *"SUPERSU"* ]]; then
        echo "美哉！\n"
    elif [[ "${suversion}" == *"MAGISKSU"* ]]; then
        echo "你是闲得慌吗？\n能解锁的自己刷 TWRP 去，不需要这个！" 1>&2
        exit 1
    else
        echo "我有些不清楚你的 su 提供方是谁，不过注意点总是对的\n"
    fi
else
    echo "本脚本需要 root 权限才可以使用！ \n请输入 'su' 以获取 root 权限" 1>&2
    exit 1
fi





SELINUX_MODE="$(getenforce)"
pwdo="$(pwd)"
setenforce 0
cd '/'



TWRP_FILE_DIR_OLD="/sdcard/TWRP"
TWRP_FILE_DIR_AUTO="$(exec_dirname ${0})"
TWRP_FILE_DIR_RC='/sdcard/External_Recovery--rc'
TWRP_FILE_DIR_DEFAULT='/sdcard/External_Recovery'
TWRP_FILE_DIR_SYSTEM='/system/res/External_Recovery'
TWRP_FILE_DIR_APK='/data/data/me.funnypro.qkmptros/External_Recovery'

if [[ -f "${TWRP_FILE_DIR_AUTO}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_AUTO}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_AUTO}"
    cd "${pwddir}"
elif [[ -f "${TWRP_FILE_DIR_RC}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_RC}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_RC}"
    cd "${pwddir}"
elif [[ -f "${TWRP_FILE_DIR_DEFAULT}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_DEFAULT}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_DEFAULT}"
    cd "${pwddir}"
elif [[ -f "${TWRP_FILE_DIR_SYSTEM}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_SYSTEM}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_SYSTEM}"
    cd "${pwddir}"
elif [[ -f "${TWRP_FILE_DIR_APK}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_APK}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_APK}"
    cd "${pwddir}"
elif [[ -f "${TWRP_FILE_DIR_OLD}/TWRP_file/sbin.tar.gz" && -s "${TWRP_FILE_DIR_OLD}/TWRP_file/sbin.tar.gz" ]]; then
    export pwddir="${TWRP_FILE_DIR_OLD}"
    cd "${pwddir}"
else
    echo 'Fa♂Q' 1>&2
    exit 1
fi




if [[ "${0}" == '/system/bin/factory' ]]; then
    sh ./TWRP_file/shell/recovery.sh &
fi




echo "\a"
echo "欢迎使用360F4移动版外挂TWRP"
echo "TWRP版本:TWRP3.1.1-0 "
echo "本V5制作为小w "
echo "更新内容请查看readme"
echo "请确定为型号是否为1501_M02\n"




restoreselinux(){
if [[ "${SELINUX_MODE}" != 'Permissive' ]]; then
    setenforce 1
fi
}



menu(){

    echo "  菜单 "
    echo "1.查看说明书以及更新日志"
    echo "2.重启手机"
    echo "3.热重启"
    echo "4.退出"
    echo "5.直接进入TWRP"
    echo "请输入你的选项"
}




echo "请按回车键进入菜单"
read var


menu
read srtin
case "${srtin}" in
1)
    cat ./readme.txt
    restoreselinux
    cd "${pwdo}"
;;
2)
    reboot
;;
3)
    exec_killall -9 system_server
;;
4)
    restoreselinux
    cd "${pwdo}"
    exit
;;
5)
    LOGDIR='/data/local/tmp/External_TWRP.log'
    echo '----------------------------------------------------------------------------------------------------' >> "${LOGDIR}"
    #!/system/bin/sh -x
    echo "\a"
    echo "请在5秒内关闭你输入法窗口\n否则后果自负"
    sleep 5
    sh -x ./TWRP_file/shell/recovery.sh 2>&1 >> "${LOGDIR}" &
;;
*)
    echo '你输入了错误的选项' 1>&2
    restoreselinux
    cd "${pwdo}"
    exit 1
;;
esac
