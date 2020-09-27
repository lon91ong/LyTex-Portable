@echo off

:: need to change drive first
%~d0
cd %~dp0

set lytexdir=..\..
set lyxdir=..\..\LyX
 
:: wget need the slash at the end when listing files 
::set lyxpath=ftp://ftp.lyx.org/pub/lyx/bin/

setlocal enabledelayedexpansion
set downdir=..\download
for /f "delims=" %%i in ('dir /B /X  %downdir%\LyX*') do (set lyxname=%%i)
:extractlyx

echo Extracting LyX installer...
echo.
if exist %downdir%\LyX rmdir /s /q %downdir%\LyX
7z x -y -o%downdir%\LyX %downdir%\%lyxname%
if ERRORLEVEL 1 echo Error while extracting LyX installer! & pause & exit 

::pause

:clearlyx

echo.
echo Tidying new LyX directory...
echo. 
::@echo on
::pause
:: when Resources folder exists in LyX directory, move command does nothing!
::move /y %downdir%\LyX\$_OUTDIR\Resources %downdir%\LyX
::xcopy /e/i/y %downdir%\LyX\$_OUTDIR\Python %downdir%\LyX\Python

::rmdir /s /q %downdir%\LyX\$_OUTDIR
rmdir /s /q %downdir%\LyX\$PLUGINSDIR
rmdir /s /q %downdir%\LyX\$_1_
::::rmdir /s /q %downdir%\LyX\aiksaurus\$PLUGINSDIR

::::copy /y %downdir%\LyX\bin\Microsoft.VC90.CRT.manifest %downdir%\LyX\ghostscript
copy /y %downdir%\LyX\bin\msvc*dll %downdir%\LyX\ghostscript
::copy /y %downdir%\LyX\bin\msvcr100.dll %downdir%\LyX\ghostscript
rmdir /s /q %downdir%\LyX\ghostscript\$PLUGINSDIR

::::copy /y %downdir%\LyX\bin\Microsoft.VC90.CRT.manifest %downdir%\LyX\python
copy /y %downdir%\LyX\bin\msvc*.dll %downdir%\LyX\Python
::copy /y %downdir%\LyX\bin\msvcr100.dll %downdir%\LyX\Python
rem LyX-Installer doesn't put msvcrt in this directiory
::::copy /y %downdir%\LyX\bin\Microsoft.VC90.CRT.manifest %downdir%\LyX\imagemagick
copy /y %downdir%\LyX\bin\msvc*.dll %downdir%\LyX\imagemagick
::copy /y %downdir%\LyX\bin\msvcr100.dll %downdir%\LyX\imagemagick

rem LyX-Installer doesn't put these pdfopen.exe and System.dll in this directiory
::copy /y %lyxdir%\bin\pdfopen.exe %downdir%\LyX\bin
copy /y %lyxdir%\bin\System.dll %downdir%\LyX\bin
::xcopy /e/i/y %~dp0sometex\basic-lyx %~dp0LyTeX\LyX
if not exist %downdir%\LyX\local mkdir %downdir%\LyX\local
xcopy /e/i/y  %lyxdir%\local %downdir%\LyX\local
mkdir %downdir%\LyX\Resources\templates\ChineseSimp
xcopy /e/i/y  %lyxdir%\Resources\templates\ChineseSimp %downdir%\LyX\Resources\templates\ChineseSimp

::pause

echo.
echo Removing old LyX files...
echo.

::::rmdir /s /q %lyxdir%\aiksaurus
rmdir /s /q %lyxdir%\bin
rmdir /s /q %lyxdir%\ghostscript
rmdir /s /q %lyxdir%\imagemagick
rmdir /s /q %lyxdir%\local
rmdir /s /q %lyxdir%\Python
rmdir /s /q %lyxdir%\Resources

echo Moving new LyX files to LyX directory...
echo.

::::move /y %downdir%\LyX\aiksaurus %lytexdir%\LyX
move /y %downdir%\LyX\bin %lytexdir%\LyX
move /y %downdir%\LyX\ghostscript %lytexdir%\LyX
move /y %downdir%\LyX\imagemagick %lytexdir%\LyX
move /y %downdir%\LyX\local %lytexdir%\LyX
move /y %downdir%\LyX\Python %lytexdir%\LyX
move /y %downdir%\LyX\Resources %lytexdir%\LyX

rmdir /s /q %downdir%\LyX

:theEnd

pause
endlocal
