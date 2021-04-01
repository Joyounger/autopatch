# autopatch
apply *.patch file provided by google automatic

脚本用法:  
每次执行脚本前打开脚本, 编辑这几个变量的值  
1 androidroot 填android源码根目录  
2 patchroot 填补丁文件根目录,到platform一级,如~/tools/spatchfiles/bulletin_2019_07_preview_v2/patches/android-9.0.0_r1/platform  
3 branch 在哪个分支合填哪个  
4 YEAR 补丁是哪年  
5 MONTH 补丁是哪月的  
填好之后运行:bash aosp_gitproj_strcture.sh  
脚本执行完之后,会提示要不要自动自交到gerrit,这时看脚本输出中有没有error等冲突报错  
如果没有,就输入'y'并回车,之后git会自动提交,自己只需要填写每个仓库下活动的提交信息即可.  
如果有,说明patch本身有冲突, 必须手动对照补丁修改,这时就重开一个终端,手动修改完后回到之前终端输入'y'并回车  
