@echo off

set PROMPT=texshell$G

set TEXDIR=%~dp0
set tldrive=%~d0

%tldrive%
cd %TEXDIR%

set TEXMFCNF=%TEXDIR%
set TEXMFMAIN=%TEXDIR%
set TEXMFDIST=%TEXDIR%texmf-dist
set TEXMFLOCAL=%TEXDIR%texmf-local
set TEXMFVAR=%TEXDIR%texmf-var
set TEXMF=%TEXDIR%
set TEXMFDBS={!!%TEXDIR%texmf-config,!!%TEXMFVAR%,!!%TEXMFLOCAL%,!!%TEXMFDIST%}

set FONTCONFIG_FILE=
set FONTCONFIG_PATH=
set FC_CACHEDIR=

set TEXBINDIR=%TEXDIR%bin\win32
set platform=win32
set PATH=%TEXBINDIR%;%PATH%
if "%1" equ "texmgr" (
rem start tlmgr
rem can't change "rem" to "::" in the following line! 
	cmd /C "tlmgr update --list"
rem 	start "title" "tlmgr-gui.vbs"
rem 	exit
)
if "%1" equ "init" (
	@echo Initialize the TinyTeX environment
	tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet

rem 	ref:https://www.tug.org/texlive/doc/tlmgr.html#update-option...-pkg
rem 	tlmgr update --self
	tlmgr install --force texworks ctex CJK xeCJK xetex3
	texhash.exe
	@echo Initialize environment Done!
	ping 127.0.0.1 -n 6 > nul
	for /f %%b in ('dir /B /S /X *.log') do (del /q %%b)
	for /f %%c in ('dir /B /S /X *.pdf') do (del /q %%c)
	for /f %%d in ('dir /B /S /X *.txt') do (del /q %%d)
rem 	exit
)

:: start texshell
set Path=%~dp0tlpkg\tlgs\bin;%Path%
cd ..
set gs_lib=%cd%\TinyTeX\tlpkg\tlgs\lib;%cd%\TinyTeX\tlpkg\tlgs\fonts;
set gs_dll=%cd%\TinyTeX\tlpkg\tlgs\bin\gsdll32.dll
texhash
if exist "%USERPROFILE%\My Documents\texdoc" (
    %HOMEDRIVE%
    cd %HOMEPATH%\My Documents\texdoc
    for %%i in (*.aux) do del %%i
    for %%i in (*.dvi) do del %%i
    for %%i in (*.log) do del %%i
    for %%i in (*.synctex) do del %%i
    )
call cmd

::pause
