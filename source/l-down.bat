@echo off

set downdir=%~dp0download

set Path=%~dp0somebin;%Path%

::==================== LyX ========================
:downlyx

set lyxver=2.3.6
rem set lyxpath=ftp://ftp.lyx.org/pub/lyx/bin/%lyxver%
set lyxpath=https://mirrors.tuna.tsinghua.edu.cn/lyx/bin/%lyxver%
set lyxname=LyX-%lyxver:.=%1-Installer-3-x64.exe

echo.
echo Downloading LyX installer...

if not exist %downdir%\%lyxname% (
wget -c -P %downdir% --no-check-certificate %lyxpath%/%lyxname%
)

if "%buildtex%"=="texlive" ( goto downlive ) else ( goto downmik )

::==================== MiKTeX ========================
:downmik

set mknet=https://mirrors.tuna.tsinghua.edu.cn/ctan/systems/win32/miktex/setup/windows-x86/
::set mkbin=miktex-portable-2.9.6521.exe
set mkbin=basic-miktex.exe

echo.
echo Downloading MiKTeX installer...

:: --retr-symlinks option is used for ftp connection
if not exist %downdir%\%mkbin% (
rem wget --retr-symlinks -nv -N -P %downdir% %mknet%/%mkbin%
wget -c -O %downdir%/miktex-portable.exe --no-check-certificate %mknet%/%mkbin%
)

::pause

goto downend

::==================== TeXLive ========================
:downlive

echo.
echo Downloading TinyTex.zip ...
set tinytex=https://yihui.org/tinytex/TinyTeX.zip
if not exist %downdir%/TinyTeX.zip (
wget -c -O %downdir%/TinyTeX.zip --no-check-certificate %tinytex%
)

::pause

goto downend

::==================== The End ========================
:downend

pause
