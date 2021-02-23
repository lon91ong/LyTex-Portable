@echo off
set PROMPT=# 

rem ------------------------------------------
rd /s /q LyTeX\Manual
del /q LyTeX\LyX\lyx.usb
del /q LyTeX\LyX\temp.usb
del /q LyTeX\LyX\Uninstall-LyX.exe

rem rmdir /s /q Resources\doc\ca
rem rmdir /s /q Resources\doc\cs
rem rmdir /s /q Resources\doc\da
rem rmdir /s /q Resources\doc\de
rem rmdir /s /q Resources\doc\es
rem rmdir /s /q Resources\doc\eu
rem rmdir /s /q Resources\doc\fr
rem rmdir /s /q Resources\doc\gl
rem rmdir /s /q Resources\doc\he
rem rmdir /s /q Resources\doc\hu
rem rmdir /s /q Resources\doc\it
rem rmdir /s /q Resources\doc\ja
rem rmdir /s /q Resources\doc\nb
rem rmdir /s /q Resources\doc\nl
rem rmdir /s /q Resources\doc\pl
rem rmdir /s /q Resources\doc\pt
rem rmdir /s /q Resources\doc\ro
rem rmdir /s /q Resources\doc\ru
rem rmdir /s /q Resources\doc\sk
rem rmdir /s /q Resources\doc\sl
rem rmdir /s /q Resources\doc\sv
rem rmdir /s /q Resources\doc\uk

rem cd Resources\examples
rem for /D %%a in (*) do (
rem     if %%a neq en if %%a neq zh_CN if %%a neq zh_TW (
rem     rmdir /s /q %%a
rem     )
rem )
rem cd ..\..

rem cd Resources\locale
rem for /D %%a in (*) do (
rem     if %%a neq en if %%a neq zh_CN if %%a neq zh_TW (
rem     rmdir /s /q %%a
rem     )
rem )
rem cd ..\..

del /q LyTeX\LyX\Python\Lib\*.pyc

rmdir /s /q LyTeX\LyX\local
xcopy /e/i/y somelyx LyTeX\LyX

rem --------------------------------------------------

del /q  LyTeX\Common\download\*

:: ===================================================

if "%buildtex%"=="texlive" ( goto tidylive ) else ( goto tidymik )

::==================== MiKTeX ========================
:tidymik

rmdir /s /q LyTeX\MiKTeX\texmfs\doc
rmdir /s /q LyTeX\MiKTeX\texmfs\source

rmdir /s /q LyTeX\MiKTeX\texmfs\fonts\pk
rmdir /s /q LyTeX\MiKTeX\texmf-local\fonts\pk
::rmdir /s /q texmf-var\fonts\pk

del /q LyTeX\MiKTeX\texmfs\fonts\cache\*
del /q LyTeX\MiKTeX\texmf-local\fonts\cache\*
::del /q texmf-var\fonts\cache\*

::rmdir /s /q texmf-var\web2c
::rmdir /s /q temp

rem ---------------- TeXworks -------------------------

xcopy /e/i/y texworks\TUG LyTeX\MiKTeX\texmf-local\TUG

LyTeX\MiKTeX\texmfs\miktex\bin\texhash.exe

goto tidyend

::==================== TeXLive ========================
:tidylive

:: texlive is too large for including these manuals.

del /q LyTeX\Manual\chinese\lnotes.pdf
del /q LyTeX\Manual\english\lshort.pdf

rem ------------------------------------------------

rem rmdir /s /q LyTeX\TinyTex\texmfs\fonts\pk
rmdir /s /q LyTeX\TinyTex\texmf-local\fonts\pk
rmdir /s /q LyTeX\TinyTex\texmf-dist\fonts\pk
rmdir /s /q LyTeX\TinyTex\texmf-var\fonts\pk

rem del /q LyTeX\TinyTex\texmfs\fonts\cache\*
del /q LyTeX\TinyTex\texmf-local\fonts\cache\*
del /q LyTeX\TinyTex\texmf-dist\fonts\cache\*
del /q LyTeX\TinyTex\texmf-var\fonts\cache\*

rem del /q LyTeX\TinyTex\texmfs\ls-R
del /q LyTeX\TinyTex\texmf-local\ls-R
del /q LyTeX\TinyTex\texmf-dist\ls-R
del /q LyTeX\TinyTex\texmf-var\ls-R
rem del /q LyTeX\TinyTex\*.lst

rem rmdir /s /q LyTeX\TinyTex\texmf-var\web2c
rmdir /s /q LyTeX\TinyTex\temp

rem ----------------- TeXworks ------------------------

rmdir /s /q  LyTeX\TinyTex\tlpkg\texworks\templates
xcopy /e/i/y texworks LyTeX\TinyTex\tlpkg\texworks

rmdir /s /q  LyTeX\TinyTex\tlpkg\texworks\completion
rmdir /s /q  LyTeX\TinyTex\tlpkg\texworks\translations
rmdir /s /q  LyTeX\TinyTeX\tlpkg\texworks\texworks-help

LyTeX\TinyTex\bin\win32\texhash.exe

goto tidyend

::==================== The End ======================== 
:tidyend
::pause
