@echo off
setlocal enabledelayedexpansion

:: 使用 PowerShell 弹窗获取中文标题
for /f "delims=" %%i in ('powershell -command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('请输入文章标题', '创建新文章')"') do (
    set "TITLE=%%i"
)

if "%TITLE%"=="" (
    echo 已取消，未输入标题。
    exit /b 1
)

:: 调用 Python 生成拼音 slug
for /f "delims=" %%i in ('python "%~dp0to_slug.py" "%TITLE%"') do (
    set "SLUG=%%i"
)

:: 获取日期
for /f "tokens=1-3 delims=/- " %%a in ('wmic os get localdatetime ^| find "."') do (
    set "DATE=%%a-%%b-%%c"
)

:: 创建 Markdown 文件
set "POST_FILE=content\posts\!SLUG!.md"
echo --- > !POST_FILE!
echo title: "%TITLE%" >> !POST_FILE!
echo date: %DATE%T00:00:00+08:00 >> !POST_FILE!
echo draft: false >> !POST_FILE!
echo --- >> !POST_FILE!
echo # %TITLE% >> !POST_FILE!

:: 自动 Git
git add .
git commit -m "📝 新文章: %TITLE%"
git push

:: 自动打开 VSCode
code "!POST_FILE!"

exit /b
