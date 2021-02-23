@echo off
set PROMPT=# 
set mainver=2.3a
set mainbin=LyTeX-%mainver%-bin.exe
set mainsrc=LyTeX-%mainver%-src.zip

:: miktex or texlive
set buildtex=texlive

if "%buildtex%"=="miktex" (
	rmdir /s /q %texdir%\texmfs\doc
	rmdir /s /q %texdir%\texmfs\source
) else (
	xcopy /e/i/y %~dp0sometex\basic-live %~dp0LyTeX\TinyTex
	move /y %~dp0LyTeX\TinyTex\About.htm %~dp0LyTeX
)
::pause
:maketidy

call l-tidy.bat
if "%buildtex%"=="miktex" (
	del /q %~dp0LyTeX\MiKTeX\texmf-local\miktex\cache\packages\*
	del /q %~dp0LyTeX\MiKTeX\texmf-local\miktex\log\*
)

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
