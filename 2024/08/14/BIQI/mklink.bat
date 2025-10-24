chcp 65001
@echo off
setlocal enabledelayedexpansion


:: 手动指定需要处理的DD列表（空格分隔多个值）
set "DD_LIST=IQA web ISP"

:: 循环处理每个DD值
for %%d in (%DD_LIST%) do (
   set "DD=%%d"
    set "txtfile=!DD!.txt"  :: 用!DD!获取当前循环的DD值
    @echo on
    echo DD值：!DD!          :: 用!DD!显示当前DD
    echo 对应文件：!txtfile! :: 用!txtfile!显示当前文件
    @echo off

:: 检查txt文件是否存在
if not exist "!txtfile!" (
    echo 错误：未找到文件 "!txtfile!"
    pause
    exit /b 1
)

:: 读取txt文件每行内容并创建链接
for /f "delims=" %%x in ('type "!txtfile!"') do (

    
    
    :: 跳过空行
    if "%%x"=="" (
        echo 跳过空行
        continue
    )

    echo 正在处理：%%x
    
    :: 定义路径（使用引号包裹避免空格问题）
    set "src_file=D:\Note\obsidian\OBSIDIAN_note\typora\!DD!\%%x.md"
    set "dest_file=D:\Note\CODE\Blog\hexo-blog\source\_posts\%%x.md"
    
    :: 创建文件符号链接（额外处理括号转义）
    if exist "!src_file!" (
        

        cmd /c mklink "!dest_file!" "!src_file!"
        @echo off
        if !errorlevel! equ 0 (
            echo 文件链接创建成功
        ) else (
	    echo mklink "!dest_file!" "!src_file!"
            echo 文件链接创建失败
        )
    ) else (
        echo 源文件不存在：!src_file!，跳过
    )
    
    :: 定义目录路径
    set "src_dir=D:\Note\obsidian\OBSIDIAN_note\typora\!DD!\%%x"
    set "dest_dir=D:\Note\CODE\Blog\hexo-blog\source\_posts\%%x"
    
    :: 创建目录符号链接
    if exist "!src_dir!\" (
        cmd /c mklink /D "!dest_dir!" "!src_dir!"
        if !errorlevel! equ 0 (
            echo 目录链接创建成功
        ) else (
            echo  mklink /D "!dest_dir!" "!src_dir!"

            echo 目录链接创建失败
        )
    ) else (
        echo 源目录不存在：!src_dir!，跳过
    )
)
)

echo 所有项目处理完成
pause
endlocal
