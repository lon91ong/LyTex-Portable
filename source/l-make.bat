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

::set mkbin=miktex-portable-2.9.6521.exe
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

xcopy /e/i/y sometex\basic-mik %texdir%
move /y %texdir%\About.htm %~dp0LyTeX

xcopy /e/i/y sometex\basic-bin %texdir%\texmfs\miktex\bin

rem texmf-local 

if not exist %texdir%\texmf-local mkdir %texdir%\texmf-local

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
call %texdir%\miktex-portable.cmd
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

::if not exist %~dp0LyTeX\TeXLive md %~dp0LyTeX\TeXLive

::goto addons

:extract

echo ===========================================
echo Now starting to extract TeXLive packages...
echo ===========================================

7z x -y -o%~dp0LyTeX %downdir%\TinyTex.zip
ren %~dp0LyTeX\TinyTex TeXLive
set outdir=%~dp0LyTeX\TeXLive

:cleartl

rem remove tlpkg, doc and source dir
:: rmdir /s /q %outdir%\tlpkg
rmdir /s /q %outdir%\texmf-dist\doc
rmdir /s /q %outdir%\texmf-dist\source
::rmdir /s /q %outdir%\texmfs\doc
::rmdir /s /q %outdir%\texmfs\source
::rmdir /s /q %outdir%\texmf-local\doc
::rmdir /s /q %outdir%\texmf-local\source
:: rmdir /s /q %outdir%\ctxdir

::rmdir /s /q %outdir%\readme-html.dir
::rmdir /s /q %outdir%\readme-txt.dir
::del /q %outdir%\install-tl.log
::del /q %outdir%\doc.html
::del /q %outdir%\index.html
del /q %outdir%\texmf.cnf 
::del /q %outdir%\README.usergroups
::del /q %outdir%\README
del /q %outdir%\install-tl
::del /q %outdir%\tl-portable
::del /q %outdir%\install-tl.bat
del /q %outdir%\install-tl-windows.bat
::del /q %outdir%\tl-portable.bat

:: =============================================

::pause

:addons

xcopy /e/i/y sometex\basic-live %outdir%
move /y %outdir%\About.htm %~dp0LyTeX

set tlpdb=%outdir%\tlpkg\texlive.tlpdb
set objdir=%outdir%\tlpkg\tlpobj

if exist %tlpdb% del /q %tlpdb%
::echo type %objdir%\00texlive-installation.config.tlpobj
::type %objdir%\00texlive-installation.config.tlpobj > %tlpdb%
::echo. >> %tlpdb%

for /f %%a in ('dir /b /o n %objdir%') do (
    echo type %objdir%\%%a
    type %objdir%\%%a >>%tlpdb%
    echo.>>%tlpdb%
) 

::for /r %objdir% %%a in (*.tlpobj) do (
::    echo type %%a
::    type %%a >>%tlpdb%
::    echo. >>%tlpdb%
::)

rem texlive 2009 supports RELOCATION of package
rem thus we replace texlive.tlpdb using perl here
"%outdir%\tlpkg\tlperl\bin\perl.exe" -p -i".txt" -e "s/RELOC/texmf-dist/g" "%outdir%\tlpkg\texlive.tlpdb"
del /q %outdir%\tlpkg\texlive.tlpdb.txt 

xcopy /e/i/y sometex\basic-bin %outdir%\bin\win32

rem editor

if not exist %outdir%\tlpkg\texworks mkdir %outdir%\tlpkg\texworks
xcopy /e/i/y %~dp0texworks %outdir%\tlpkg\texworks

rem texmf-local 

if not exist %outdir%\texmf-local mkdir %outdir%\texmf-local

xcopy /e/i/y sometex\basic-tex %outdir%
xcopy /e/i/y sometex\basic-cct %outdir%
xcopy /e/i/y sometex\basic-cjk %outdir%

%outdir%\bin\win32\texhash.exe

::pause

goto makeend

::==================== TheEnd ========================
:makeend

echo All are done!

pause
