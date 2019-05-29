exec_command(){


    txxbox(){
        if [[ "${check_toolbox_command_callback}" == '0' ]]; then
            shift
            exec toolbox "${@}"
        elif [[ "${check_toybox_command_callback}" == '0' ]]; then
            shift
            exec toybox "${@}"
        fi
    }

    #实体劫持这三个 box 后，这个函数一定会误判
    local toybox_path="$(whence toybox)"
    if [[ -s "${toybox_path}" && -r "${toybox_path}" ]]; then
        grep -a "${1}" "${toybox_path}" >/dev/null 2>&1
        local check_toybox_command_callback=$?
    fi

    local toolbox_path="$(whence toolbox)"
    if [[ -s "${toolbox_path}" && -r "${toolbox_path}" ]]; then
        grep -a "${1}" "${toolbox_path}"  >/dev/null 2>&1
        local check_toolbox_command_callback=$?
    fi

    local busybox_path="$(whence busybox)"
    if [[ -s "${busybox_path}" && -r "${busybox_path}" ]]; then
        grep -a "${1}" "${busybox_path}" >/dev/null 2>&1
        local check_busybox_command_callback=$?
    fi



    #我能怎么办？我才是最绝望的吧！
    local command_path="$(whence ${1})"
    [[ -n "${command}" ]] && local check_command_callback='0'




    #if [[ "${1}" == "txxbox" ]]; then

    if [[ "${1}" == "*box" ]]; then
        exec "${@}"
    elif [[ "${check_busybox_command_callback}" == '0' ]]; then
        exec busybox "${@}"
    elif [[ "${check_toolbox_command_callback}" == '0' ]]; then
        exec toolbox "${@}"
    elif [[ "${check_toybox_command_callback}" == '0' ]]; then
        exec toybox "${@}"
    elif [[ "${check_command_callback}" == '0' ]]; then
        "${@}"
    else
        echo "! ${1} not found" >&2
        return 127
    fi
}

getopt_lite(){
    str="${1}"
    if [[ "${str:0:2}" == '--' ]]; then
        local stri="$((${#str}-2))"
        local stro="${str:2:${stri}}"
        echo "${stro}"
    elif [[ "${str:0:1}" == '-' ]]; then
        local stri="$((${#str}-1))"
        local stro="${str:1:${stri}}"
        echo "${stro}"
    fi
}

check_root(){
    if [[ "${USER_ID}" == "" ]]; then
        if [[ "${USER}" == "root" ]]; then
            USER_ID="0"
        elif id | grep -E '^uid=0(root) gid=0(root).*$' >/dev/null 2>&1 ; then
            USER_ID="0"
        elif [[ $(id | exec_cut -b 5) = "0" ]]; then
            USER_ID="0"
        fi
    fi
    [[ "${USER_ID}" != '0' ]] && echo ' root permission not to exist' >&2 && return 1
    return 0
}

check_su_provider(){
    local su_version="$(su --version)"

    #事实上，这部分是为了收集返回值用的
    su --version >/dev/null 2>&1

    case "${su_version}" in
    "*:SUPERSU")
        echo "The provider is Chainfire:SuperSU"
    ;;
    "*:MAGISKSU*")
        echo "The provider is Topjohnwu:MagiskSU"
    ;;
    #不要问我为啥这样，我的建议是问 360root 项目组 360su 有几个名字，要是只有 360su 的话我就改 360su 了
    "*:360*")
        echo "The provider is qihoo360:360SU"
    ;;
    #不要问我为啥这样，我的建议是问 kingroot 团队为啥改了很多名字
    # kingroot 部分特征文件
    #/data/data-lib/kds
    #/data/data-lib/kgod
    #/data/data-lib/tps
    "*:king*")
        #echo "The provider is tencent:kingrootSU"
        echo "The provider is kingrootteam:kingrootSU"
    ;;
    *)
        if [[ "${su_version}" =="" ]]; then
            echo "恕我直言，该 su 二进制不是垃圾就是有毛病了，因为这个 su 的 --version 参数似乎没有在 stdout 输出任何东西"
            return 1
        elif [[ "${?}" != '0' ]]
            echo "su 二进制存在吗？\n或者说：当前 su 二进制的守护进程存活吗？（特指中国大陆的部分商业 su 供应方的 su）"
            return 1
        else
            echo "有几种糟糕的情况，例如说没有收录，或者是当前 su 二进制的守护进程跪了，甚至是这东西出了 bug"
            echo "不过有一种已知 su 没有被收录，名为 koushSU"
            return 1
        fi
    ;;
    esac

}


force_mkdir(){
    [[ ! -d "${1}" ]] && rm -f "${1}"
    mkdir -p "${1}"
}
