@echo off

set downdir=%~dp0download

set Path=%~dp0somebin;%Path%

::==================== LyX ========================
:downlyx

set lyxver=2.3.5
set lyxpath=ftp://ftp.lyx.org/pub/lyx/bin/%lyxver%
set lyxname=LyX-%lyxver:.=%1-Installer-3.exe

echo.
echo Downloading LyX installer...

if not exist %downdir%\%lyxname% (
wget -nv -N -P %downdir% %lyxpath%/%lyxname%
)

if "%buildtex%"=="texlive" ( goto downlive ) else ( goto downmik )

::==================== MiKTeX ========================
:downmik

set mknet=http://mirrors.mi.ras.ru/CTAN/systems/win32/miktex/setup/windows-x86/
::set mkbin=miktex-portable-2.9.6521.exe
set mkbin=miktex-portable.exe

echo.
echo Downloading MiKTeX installer...

:: --retr-symlinks option is used for ftp connection
if not exist %downdir%\%mkbin% (
wget --retr-symlinks -nv -N -P  %downdir% %mknet%/%mkbin%
)

::pause

goto downend

::==================== TeXLive ========================
:downlive

::set tlnet=ftp://ftp.ctex.org/mirrors/CTAN/systems/texlive/tlnet/archive
rem set tlnet=http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/archive/
set tlnet=https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/

setlocal enabledelayedexpansion

if not exist download\texlive mkdir download\texlive

set texout=%~dp0download\texlive
echo.
echo Output directory is %texout%
echo.

set coldir=%~dp0somedef

:: Since string variables in dos script have length limitation,
:: We have to handle c-latexextra downloadding as two part.
:: http://support.microsoft.com/kb/830473/en-us/

for /r %coldir% %%a in (tl*.def) do (
    echo handling %%a...
    set downlist=
    for /f "tokens=1,2*" %%i in (%%a) do (
        if %%i == depend (
            set downlist=!downlist!%%j.tar.x?,
        ) 
    )
    rem downlist should NOT end with comma!
    set downlist=!downlist!collection-basic.tar.x?
    :: echo !downlist!
    wget -r -nv -np -nd -N -P !texout! -A !downlist! %tlnet%
    echo.
)

endlocal

::pause

goto downend

::==================== The End ========================
:downend

pause
