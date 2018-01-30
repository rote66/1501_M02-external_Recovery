# 360-1501_M02-external_Recovery



360F4 External TWRP  
**此 TWRP 为外挂版**  

___

关于：  
  
本外挂 `TWRP` 基于 `TWRP3.1.1-0` 制作  
底包为 `los14.1`  
适用机型 `360f4` 移动版  
既 `360-1501_M02`  
<STRIKE>虽然 `360-1501_A02` 经测试也可以使用</STRIKE>  
其他未经过测试  
理论上同分区设备可用  

___

使用方法：  
  
  
你需要准备好的东西：  
  
1. 安装 [busybox][meefik/busybox] 并在软件内点击 `Install`  
2. 安装 [终端][zt515/Ansole] <STRIKE>（虽然说什么终端都可以）</STRIKE>  
3. 一个可以进行 root 操作的文件管理器（推荐 [RE文件管理器][speedsoftware/rootexplorer] 或者是 [MT管理器][bin/mtfileManager]）  
4. 一双勤劳的手和会思考的大脑  
当这些准备好之后你就可以开始了  



使用步骤：  
  
1. 点 [这里][External-Recovery_Download] 下载外挂TWRP的压缩包，并解压到任意目录  
2. 在 [终端][zt515/Ansole] 输入 `su` 获取 root  
3. 输入 `sh` 并输入空格，然后复制 `rec` 的绝对路径并粘贴在 [终端][zt515/Ansole]  
4. 按照提示操作即可  
5. 直接进入 TWRP 时务必关闭输入法，否则……  
注：虽然说你可以直接按下HOME键，不过你需要确认终端可以在后台挂住
6. 一段时间的等待后，开始享受 `外挂式 TWRP` 的便利吧，如果出现问题请反馈  



___

制做相关：  
  
作者小w  
参照眷恋阳阳以前给F4的外挂TWRP  
感谢孤独的傻瓜，行旅途  

___

交流讨论 & 反馈：  
  
QQ群：[639102984][QQqun]  
<s>也可以去 [416190782][QQqun2] 串串门</s>  

___

目前已知问题：  
  
1. 界面容易闪  
3. 尚不明确  

___

更新日志：  
  
V5.00001： `@funnypro` 根据 `@manhong2112` 的技术支持和指导以及 `@小XIN。` 和 `@SELinux ` 还有 `@        ` （测试人员User_ID均取自QQ群名片）的多次测试做了一些微小的工作  
  
V5：修复物理按键失灵，修复 360os2.0 上用终端进入不了的问题，更新部分文件为官方。。。  
  
V4：更新 `TWRP` 为 `TWRP 3.1.1-0` 版本，尝试解决 `360os2.0 上无法启动`的问题  
  
V3：修正 system 挂载问题，修正版本异常，修复若干bug，去除自动刷入，去除之前的检测  
  
V2：替换 `TWRP` 版本为自编译 3.1.0-0 ，并且测试可以刷 `官方 OTA 包` 以及 `SuperSU` ，修复若干bug  

___
*******************
[External-Recovery_Download]:https://github.com/rote66/1501_M02-external_Recovery/releases
[funnypro/3mptros]:https://github.com/funnypro/360f4
[meefik/busybox]:https://github.com/meefik/busybox/releases
[zt515/Ansole]:http://www.coolapk.com/apk/com.romide.terminal
[topjohnwu/Magisk]:https://github.com/topjohnwu/MagiskManager/releases
[bin/mtfileManager]:http://www.coolapk.com/apk/bin.mt.plus
[speedsoftware/rootexplorer]:http://www.coolapk.com/apk/com.speedsoftware.rootexplorer
[QQqun]:https://jq.qq.com/?_wv=1027&k=5xTl0HJ
[QQqun2]:https://jq.qq.com/?_wv=1027&k=5EqB7ph
