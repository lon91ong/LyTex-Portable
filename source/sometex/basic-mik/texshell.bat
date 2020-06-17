@echo off

set PROMPT=texshell$G

set TEXDIR=%~dp0
set tldrive=%~d0

%tldrive%
cd %TEXDIR%

set TEXMFCNF=
set TEXMFMAIN=
set TEXMFDIST=
set TEXMFLOCAL=
set TEXMFVAR=
set TEXMF=

set FONTCONFIG_FILE=
set FONTCONFIG_PATH=
set FC_CACHEDIR=

set TEXBINDIR=%TEXDIR%texmfs\miktex\bin
set platform=win32
if "%1" equ "texmgr" (
start "title" "%~dp0texmfs\miktex\bin\mpm_mfc.exe"
exit
)

:: start texshell
set Path=%~dp0texmfs\miktex\bin;%Path%
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

:pause
