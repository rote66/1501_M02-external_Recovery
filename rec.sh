#!/system/bin/sh




###########################################
# MenuScript V6 for 1501_M02
# Mod by 小w
# 微小的工作 by 滑稽Pro
###########################################
version='5.1'
version_code='6'



#引入工具
. "${0%/*}/shell/utils.sh"


#调用很可能是 busybox 的命令
exec_cut(){
    exec_command cut "${@}"
}
exec_pkill(){
    exec_command pkill "${@}"
}
exec_telnet(){
    exec_command telnet "${@}"
}




#判断是否以root进程执行
check_root 2>/dev/null
[[ "${?}" != '0' ]] && echo "本脚本需要 root 权限才可以使用！ \n请输入 'su' 以获取 root 权限" >&2 && exit 1



TWRP_FILE_PATH_AUTO="${0%/*}"
TWRP_FILE_PATH_TEST='/sdcard/External_Recovery-test'
TWRP_FILE_PATH_DEFAULT='/sdcard/External_Recovery'
TWRP_FILE_PATH_SYSTEM='/system/res/External_Recovery'
TWRP_FILE_PATH_APP='/data/user/0/org.funnyshenzhou.qkfffrs/files/External_Recovery'




check_twrp_dir(){
    if [[ -s "${1}/TWRP_ramdisk.tar.gz" ]]; then
        export TWRP_FILE_PATH="${1}"
    fi
}

check_twrp_dir "${TWRP_FILE_PATH_SYSTEM}"
check_twrp_dir "${TWRP_FILE_PATH_APP}"
check_twrp_dir "${TWRP_FILE_PATH_DEFAULT}"
check_twrp_dir "${TWRP_FILE_PATH_TEST}"
check_twrp_dir "${TWRP_FILE_PATH_AUTO}"



cat <<-EOF
"欢迎使用360F4移动版外挂 TWRP"
"TWRP 版本：TWRP3.1.1-0 "
"更新内容请查看项目主页"
"请确定使用 SuperSU 时禁用了“分类挂载命名空间”，或者使用 su --mount-master 来获得公共挂载命名空间"
"请确定为型号是否为 1501_M02"
EOF
echo "\a"



load_ETWRP(){
    [[ $(getopt_lite "${1}") == 'debug' ]] && debug_mode=true
    

    text
    sleep 5
    if [[ ${debug_mode} == 'true' ]]; then
        STDOUTDIR='/data/local/tmp/External_TWRP.out'
        echo '----------begin----------' >> "${STDOUTDIR}"
        export debug_mode=true exec sh -x "${TWRP_FILE_PATH}/shell/freed_recovery.sh" >> "${STDOUTDIR}" 2>&1
    else
        sh "${TWRP_FILE_PATH}/shell/recovery.sh"
    fi
}




if [[ "${0}" == '/system/bin/factory' ]]; then
    echo '发现已劫持 /system/bin/factory 文件,当前似乎进入了工厂模式'
    load_ETWRP
fi



menu(){

    cat <<-EOF
"  菜单 "
#"0. 查看说明书以及更新日志" #去 github 看
"1. 重启设备"
"2. 软重启"
"3. 伪兼容方式启动 TWRP"
"4. 退出"
"5. 进入 TWRP"
"6. 打开 telnet"
"7. debug 进入 TWRP"
"请输入你的选项"
EOF
    echo -n "\a"
}

text(){
    echo -n "\a"
    echo "请在5秒内关闭你输入法\n否则后果自负"
}


echo "请按回车键进入菜单"
read tmp_var

menu
read input
case "${input}" in
'0')
    echo "将来会跳转到项目 readme 页"
    cat "${TWRP_FILE_PATH}/readme.txt"
;;
'1')
    reboot
;;
'2')
    stop ; start
;;
'3')
    echo 'TODO'
    echo "因为我不知道为什么有的时候进入 TWRP 会失败"
    exit
;;
'4')
    exit 0
;;
'5')
    load_ETWRP
;;
'6')
    exec_telnet -l /system/bin/sh
;;
'7')

    load_ETWRP --debug
;;
*)
    echo '你输入了错误的选项' >&2
    exit 1
;;
esac
