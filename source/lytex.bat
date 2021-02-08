@echo off

rem :: texname=MiKTeX or texname=TeXLive
rem set  texname=%~n0
rem :: echo %texname%

set mainver=2.3a
set mainsrc=LyTeX-%mainver%-src.zip

set Path=%~dp0somebin;%Path%

:: buildtex=miktex or buildtex=texlive
set buildtex=miktex
if "%buildtex%"=="texlive" ( set mainbin=LyTeX-%mainver%-Liv.exe ) else ( set mainbin=LyTeX-%mainver%-Mik.exe )

:maketidy

if not exist source call l-down.bat
if not exist source call l-make.bat
call l-tidy.bat

:buildnsi

call "%~dp0nsis\makensis.exe" %~dp0somensi\LyX.nsi
call "%~dp0nsis\makensis.exe" %~dp0somensi\TeXworks.nsi
call "%~dp0nsis\makensis.exe" %~dp0somensi\Setup.nsi
call "%~dp0nsis\makensis.exe" %~dp0somensi\LyTeX.nsi

if exist source (
	7z a -tzip %mainsrc% source -xr!.svn
)

echo All are done!

::pause
