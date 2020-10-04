@echo off
cd %~dp0
@echo | install-tl-windows.bat -no-gui -profile=%~dp0tinytex.profile
setlocal enabledelayedexpansion

@echo on
call %~dp0bin\win32\tlmgr path add
call %~dp0bin\win32\tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
call %~dp0bin\win32\texhash.exe

endlocal
:cleartl
@echo off
del /q %~dp0install-tl.log
del /q %~dp0texmf.cnf
del /q %~dp0install-tl
del /q %~dp0install-tl-windows.bat
del /q %~dp0tinytex.profile

@echo.
@echo Init TexLive finished.
ping 127.0.0.1 -n 6 > nul
del %0