@echo off

rem :: texname=MiKTeX or texname=TeXLive
rem set  texname=%~n0
rem :: echo %texname%

set mainver=2.3a
set mainbin=LyTeX-%mainver%-bin.exe
set mainsrc=LyTeX-%mainver%-src.zip

set Path=%~dp0somebin;%Path%

:: miktex OR texlive
set buildtex=texlive

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
if "%buildtex%"=="texlive" ( ren %mainbin% LyTeX-%mainver%-tl.exe ) else ( ren %mainbin% LyTeX-%mainver%-mk.exe )
echo All are done!

::pause
