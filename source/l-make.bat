@echo off
set PROMPT=# 

set downdir=%~dp0download

set Path=%~dp0somebin;%Path%

if not exist %~dp0LyTeX mkdir %~dp0LyTeX

::==================== LyX ========================
:makelyx

for /f "delims=" %%i in ('dir /B /X  .\download\LyX*') do (set lyxname=%%i)
set lyxver=%lyxname:~4,1%.%lyxname:~5,1%.%lyxname:~6,1%

:lyxinst

rem if not exist %downdir%\%lyxname% goto altinst

echo.
echo Extracting LyX...

7z x -y -o%~dp0LyTeX\LyX %downdir%\%lyxname%

::pause

:: move command sucks when destination directory is not empty
::move /y %~dp0LyTeX\LyX\$_OUTDIR\Resources %~dp0LyTeX\LyX
if not exist %~dp0LyTeX\LyX\Resources mkdir %~dp0LyTeX\LyX\Resources
xcopy /e/i/y %~dp0LyTeX\LyX\Resources %~dp0LyTeX\LyX\Resources
xcopy /e/i/y %~dp0LyTeX\LyX\Python %~dp0LyTeX\LyX\Python

::rmdir /s /q %~dp0LyTeX\LyX\$_OUTDIR
rmdir /s /q %~dp0LyTeX\LyX\$PLUGINSDIR
rmdir /s /q %~dp0LyTeX\LyX\$_1_
::rmdir /s /q %~dp0LyTeX\LyX\Perl
::::rmdir /s /q %~dp0LyTeX\LyX\aiksaurus\$PLUGINSDIR

::::copy %~dp0LyTeX\LyX\bin\Microsoft.VC90.CRT.manifest %~dp0LyTeX\LyX\ghostscript
copy %~dp0LyTeX\LyX\bin\msvc*.dll %~dp0LyTeX\LyX\ghostscript
::copy %~dp0LyTeX\LyX\bin\msvcr100.dll %~dp0LyTeX\LyX\ghostscript
rem there is an aspelldata.exe file in this directory
rmdir /s /q %~dp0LyTeX\LyX\ghostscript\$PLUGINSDIR

::::copy %~dp0LyTeX\LyX\bin\Microsoft.VC90.CRT.manifest %~dp0LyTeX\LyX\python
copy %~dp0LyTeX\LyX\bin\msvc*.dll %~dp0LyTeX\LyX\Python
::copy %~dp0LyTeX\LyX\bin\msvcr100.dll %~dp0LyTeX\LyX\Python
rem LyX-Installer doesn't put msvcrt in this directiory
::::copy %~dp0LyTeX\LyX\bin\Microsoft.VC90.CRT.manifest %~dp0LyTeX\LyX\imagemagick
copy %~dp0LyTeX\LyX\bin\msvc*.dll %~dp0LyTeX\LyX\imagemagick
::copy %~dp0LyTeX\LyX\bin\msvcr100.dll %~dp0LyTeX\LyX\imagemagick
rem LyX-Installer doesn't put these two files in this directiory

xcopy /e/i/y %~dp0somelyx %~dp0LyTeX\LyX

echo Copying Documents...
if not exist %~dp0LyTeX\Manual mkdir %~dp0LyTeX\Manual
xcopy /e/i/y %~dp0somedoc %~dp0LyTeX\Manual

:version

echo Writing LyX version...
if not exist %~dp0LyTeX\Common\update mkdir %~dp0LyTeX\Common\update
>%~dp0LyTeX\Common\update\lyxver.usb echo %lyxver%

echo Copying LyX update files...
copy %~dp0somebin\wget.exe %~dp0LyTeX\Common\update
copy %~dp0somebin\7z.dll %~dp0LyTeX\Common\update
copy %~dp0somebin\7z.exe %~dp0LyTeX\Common\update
copy %~dp0somebat\update.bat %~dp0LyTeX\Common\update

if not exist %~dp0LyTeX\Common\download mkdir %~dp0LyTeX\Common\download

if "%buildtex%"=="texlive" ( goto makelive ) else ( goto makemik )

::==================== MiKTeX ========================
:makemik

set mkbin=miktex-portable.exe

if not exist %~dp0LyTeX\MiKTeX md %~dp0LyTeX\MiKTeX
set texdir=%~dp0LyTeX\MiKTeX

echo.
echo Extracting MiKTeX...

if not exist %~dp0LyTeX\MiKTeX\texmfs md %~dp0LyTeX\MiKTeX\texmfs

::7z x -y -o%~dp0LyTeX\MiKTeX\texmfs %downdir%\%mkbin%
::7z x -y -o%~dp0LyTeX\MiKTeX %downdir%\%mkbin%
echo Extract failed! Manually operate, then press any key to continue...
rem move /y %~dp0LyTeX\MiKTeX\texmfs\install %~dp0LyTeX\MiKTeX
rem rmdir /s /q %~dp0LyTeX\MiKTeX\texmfs
rem ren %~dp0LyTeX\MiKTeX\install texmfs
pause

rem texmf-local 

if not exist %texdir%\texmf-local mkdir %texdir%\texmf-local
xcopy /e/i/y sometex\basic-mik %texdir%
move /y %texdir%\About.htm %~dp0LyTeX

xcopy /e/i/y sometex\basic-bin %texdir%\texmfs\miktex\bin

xcopy /e/i/y sometex\basic-tex %texdir%
xcopy /e/i/y sometex\basic-cct %texdir%
xcopy /e/i/y sometex\basic-cjk %texdir%

rem editor

:: texworks config file lies in UserConfig or UserData dir 

if not exist %texdir%\texmf-local\TeXworks mkdir %texdir%\texmf-local\TeXworks
if not exist %texdir%\texmf-local\TeXworks\configuration mkdir %texdir%\texmf-local\TeXworks\configuration
xcopy /e/i/y %~dp0texworks\configuration %texdir%\texmf-local\TeXworks\0.6\configuration

if not exist %texdir%\texmf-local\TUG  mkdir %texdir%\texmf-local\TUG
xcopy /e/i/y %~dp0texworks\TUG %texdir%\texmf-local\TUG

echo.
echo Updating MiKTeX...
rem 命令行更新容易出问题, 还是用 %texdir%\miktex-portable.cmd 在GUI模式更新更稳妥
call %texdir%\texmfs\miktex\bin\mpm.exe"
echo Update in GUI mode, then press any key to continue...
pause >nul
::%texdir%\texmfs\miktex\bin\mpm.exe --verbose --update
::%texdir%\texmfs\miktex\bin\mpm.exe --verbose --install-some=somedef\miktex.def
::for /f %%j in (somedef\miktex.def) do (LyTeX\MiKTeX\texmfs\miktex\bin\mpm.exe --verbose --install %%j)

::echo.
::echo Updating finished. Press return to continue...
::pause>nul

rmdir /s /q %texdir%\texmfs\doc
rmdir /s /q %texdir%\texmfs\source

::pause

goto makeend

::==================== TeXLive ========================
:makelive

::if not exist %~dp0LyTeX\TinyTeX md %~dp0LyTeX\TinyTeX

::goto addons

:extract

echo ===========================================
echo Now starting to extract TeXLive packages...
echo ===========================================

7z x -y -o%~dp0LyTeX %downdir%\TinyTex.zip
rem ren %~dp0LyTeX\TinyTex TeXLive
set outdir=%~dp0LyTeX\TinyTeX

:cleartl
rem remove tlpkg, doc and source dir
:: rmdir /s /q %outdir%\tlpkg
rmdir /s /q %outdir%\texmf-dist\doc
rmdir /s /q %outdir%\texmf-dist\source
:: rmdir /s /q %outdir%\texmfs\doc
:: rmdir /s /q %outdir%\texmfs\source
:: rmdir /s /q %outdir%\texmf-local\doc
:: rmdir /s /q %outdir%\texmf-local\source
:: rmdir /s /q %outdir%\ctxdir
rem del /q %outdir%\release-texlive.txt
rem del /q %outdir%\install-tl.log
rem del /q %outdir%\texmf.cnf
rem del /q %outdir%\install-tl
rem del /q %outdir%\install-tl-windows.bat

:: =============================================

::pause

:addons

xcopy /e/i/y sometex\basic-live %outdir%
move /y %outdir%\About.htm %~dp0LyTeX

xcopy /e/i/y sometex\basic-bin %outdir%\bin\win32

rem editor

if not exist %outdir%\texmf-config\texworks mkdir %outdir%\texmf-config\texworks
xcopy /e/i/y %~dp0texworks %outdir%\texmf-config\texworks

rem texmf-local 

if not exist %outdir%\texmf-local mkdir %outdir%\texmf-local

xcopy /e/i/y sometex\basic-tex %outdir%
xcopy /e/i/y sometex\basic-cct %outdir%
xcopy /e/i/y sometex\basic-cjk %outdir%

@echo on
rem tlmgr path add
call %outdir%\bin\win32\tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
call %outdir%\bin\win32\tlmgr update --self
call %outdir%\bin\win32\tlmgr install texworks ctex CJK xeCJK xetex3 setspace pmboxdraw
call %outdir%\bin\win32\texhash.exe
@echo off

for /f %%b in ('dir /B /S /X %~dp0LyTeX\*.log') do (del /q %%b)
for /f %%c in ('dir /B /S /X %~dp0LyTeX\*.pdf') do (del /q %%c)
for /f %%d in ('dir /B /S /X %~dp0LyTeX\*.txt') do (del /q %%d)
rmdir /s /q %outdir%\texmf-config\texworks
::pause

goto makeend

::==================== TheEnd ========================
:makeend

@echo All "make steps" are done!
ping 127.0.0.1 -n 5 > nul
::pause
