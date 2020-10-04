Name "LyTeX LyX Runner"
Caption "LyX Runner"
Icon "LyX.ico"
OutFile "..\LyTeX\LyX!.exe"

SilentInstall silent
AutoCloseWindow true
ShowInstDetails nevershow

# Windows Vista settings
RequestExecutionLevel user

!include "LogicLib.nsh"

!include FileFunc.nsh
!insertmacro GetParameters

!include "WordFunc.nsh"
!insertmacro WordReplace
!insertmacro WordFind

; introduction to many nsis plugins
; http://dreams8.com/thread-7469-1-1.html

Var LYXVER ; lyx version name
Var TEXBIN ; tex binary paths

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
;LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"

Function .onInit

    #################### lyx.usb ###################
    
    IfFileExists "$EXEDIR\Common\update\lyxver.usb" +3 0
    MessageBox MB_OK "Error: Could not find $EXEDIR\Common\update\lyxver.usb!"
    Quit
    
    FileOpen $0 "$EXEDIR\Common\update\lyxver.usb" r
    FileRead $0 $1
    FileClose $0
    ;MessageBox MB_OK "LYXVER = $1"
    
    ${WordReplace} "$1" "." "" "+" $2 ; 2.2.3=> 223
    StrCpy $3 $2 2 ; 223 => 22
    StrCpy $LYXVER "$3x" ; 22 => 22x
    ;MessageBox MB_OK "LYXVER = $LYXVER"
    
    ;StrCpy $LYXVER "22x"

FunctionEnd

Section

    ${If} $%buildtex% == "texlive"
		ReadEnvStr $R0 "APPDATA"
        ;StrCpy $TEXBIN "$EXEDIR\TeXLive\bin\win32"
        StrCpy $TEXBIN "$R0\TinyTex\bin\win32"
    ${Else} ## miktex
        StrCpy $TEXBIN "$EXEDIR\MiKTeX\texmfs\miktex\bin"
    ${EndIf}

    # clear other texmf.cnf & fontconfig variables such as context-minimal's or texlive's
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("TEXMFCNF", "")'
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("TEXMFMAIN", "")'
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("TEXMFDIST", "")'
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("TEXMF", "")'
    # 3 lines below refer to : http://bbs.ctex.org/forum.php?mod=viewthread&tid=50509
    #System::Call 'kernel32::SetEnvironmentVariable(t, t) i("FONTCONFIG_FILE", "fonts.conf")'
    #System::Call 'kernel32::SetEnvironmentVariable(t, t) i("FONTCONFIG_PATH", "$EXEDIR\MiKTeX\texmf-local\fontconfig\config")'
    #System::Call 'kernel32::SetEnvironmentVariable(t, t) i("FC_CACHEDIR", "$EXEDIR\MiKTeX\texmf-local\fontconfig\cache")'
    ;ReadEnvStr $R0 "TEXMFCNF"
    ;MessageBox MB_OK $R0
    
    # set path variable
    ReadEnvStr $R0 "PATH"
    StrCpy $R0 "$TEXBIN;$EXEDIR\LyX\ghostscript;$EXEDIR\LyX\python;$EXEDIR\LyX\Perl;$EXEDIR\LyX\imagemagick;$R0"
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("Path", R0)'
    ;ReadEnvStr $R1 "PATH"
    ;MessageBox MB_OK $R1

    # set aspell path
    ${WordReplace} "$EXEDIR" "\" "/" "+" $1
    StrCpy $R1 "data-dir $1/LyX/aspell/Data;dict-dir $1/LyX/aspell/Dictionaries;home-dir $1/LyX/aspell/Personal"
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("ASPELL_CONF", R1)'

    # set LyX's UserDir environment
    System::Call 'kernel32::SetEnvironmentVariable(t, t) i("LYX_USERDIR_$LYXVER", "$EXEDIR\LyX\local")'

    # unload the System dll
    System::Free 0

    IfFileExists "$EXEDIR\LyX\local" 0 +2
    Goto done1
    CreateDirectory  "$EXEDIR\LyX\local"
    done1:

    # reset LyX's preferences file
    Delete "$EXEDIR\LyX\local\*Files.lst"
    
    #################### lyx.usb ###################

/*  When using this, there is a strange error while reading lyx.usb file! ??
    ${If} $LANGUAGE == "2052"
    ;${orIf} $LANGUAGE == "1028" ; Ҳ�������
    IfFileExists "$EXEDIR\LyX\lyx.usb" +4 0
    MessageBox MB_YESNO "��ʾ���Ƿ���Ҫ�Ķ� LyTeX �����ĵ���" IDYES true IDNO next
    true:
    ExecShell "open" "$EXEDIR\Other\chinese\lytex.pdf"
    next:
    ${EndIf}
*/

    Var /Global FORMAT4
    Var /Global XELATEX
    Var /Global EPS2PNG
    StrCpy $FORMAT4 "0"
    StrCpy $XELATEX "0"
    StrCpy $EPS2PNG "0"
    
    ClearErrors
    # append, will create an empty one if file does not exist
    IfFileExists "$EXEDIR\LyX\local\preferences" done2 0
    FileOpen $0 "$EXEDIR\LyX\local\preferences" a
    IfErrors 0 +2
    MessageBox MB_OK "Error while creating file $EXEDIR\LyX\local\preferences!"
    FileWrite $0 "\path_prefix $\"$EXEDIR\LyX\bin;$TEXBIN;$EXEDIR\LyX\python;$EXEDIR\LyX\Python\Lib;$EXEDIR\LyX\Perl\bin;$EXEDIR\LyX\imagemagick;$EXEDIR\LyX\ghostscript\bin$\"$\r$\n"
    #FileWrite $0 "\format $\"pdf4$\" $\"pdf$\" $\"PDF (XeLaTex)$\"  $\"$\"   $\"$\"   $\"$\"   $\"document,vector$\"$\r$\n"
    #FileWrite $0 "\converter $\"pdflatex$\" $\"pdf4$\" $\"xelatex $$$$i$\" $\"latex$\"$\r$\n"
    # Added in LyTeX 1.6gamma for simpler convert
    #FileWrite $0 '\converter "eps" "png" "epstopng.bat $$$$i" ""$\r$\n'
    FileClose $0
    Goto runit
    done2:
    
    ClearErrors
    # append, will create an empty one if file does not exist
    FileOpen $0 "$EXEDIR\LyX\local\preferences" a
    IfErrors 0 +2
    MessageBox MB_OK "Error while opening file $EXEDIR\LyX\local\preferences!"

    IfFileExists "$EXEDIR\LyX\temp.usb" 0 +2
    Delete $EXEDIR\LyX\temp.usb
    # append, will create an empty one if file does not exist
    FileOpen $1 "$EXEDIR\LyX\temp.usb" a
    IfErrors 0 +2
    MessageBox MB_OK "Error while opening file $EXEDIR\LyX\temp.usb!"

    ClearErrors
    loop:
        FileRead $0 $R0
        IfErrors next
        ${WordFind} $R0 " " "+1" $R1
        ;MessageBox MB_OK $R1
        ${If} "$R1" == "\path_prefix"
            ${WordFind} $R0 " " "+1}" $R2
            ${WordFind} $R2 "$\"" "+1" $R4 ; remove double quotation marks
            ;MessageBox MB_OK $R4
            # default path
            StrCpy $R8 $EXEDIR\LyX\bin;$TEXBIN;$EXEDIR\LyX\ghostscript;$EXEDIR\LyX\python;$EXEDIR\LyX\imagemagick;
            loop2:
            ClearErrors
            ${WordFind} $R4 ";" "+1" $R5 ; find first path in the string
            ${WordReplace} $R4 "$R5;" "" "+1" $R4 ; remove first path in the string
            ${If} $R4 == $R5 ; $R5 is the last path
                StrCpy $R4 ''
            ${EndIf}
            ;MessageBox MB_OK $$R5=$R5$\r$\n$$R4=$R4
            ${If} "$R5" == ""
                Goto l2done
            ${Else}
                # replaced unix path with windows path
                ${WordReplace} $R5 "/" "\" "+" $R5
                ${WordFind} $R5 "LyX\bin" "#" $R6
                #If some errors found then (result=input string)
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "LyX\ghostscript" "#" $R6
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "LyX\python" "#" $R6
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "LyX\imagemagick" "#" $R6
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "TeXLive\bin" "#" $R6
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "miktex\bin" "#" $R6
                StrCmp $R6 $R5 0 loop2
                ${WordFind} $R5 "LyX\fop" "#" $R6
                StrCmp $R6 $R5 0 loop2
                # add this path to $R8
                StrCpy $R8 $R8$R5;
                ;MessageBox MB_OK $R8
                Goto loop2
            ${EndIf}
            l2done:
            StrCpy $R0 '\path_prefix "$R8"$\r$\n'
        ${ElseIf} $R1 == \format
            ${WordFind} $R0 " " "+2" $R2
            ;MessageBox MB_OK $R1,$R2
            ${If} $R2 == $\"pdf4$\"
                ;MessageBox MB_OK FORMAT4=1
                StrCpy $FORMAT4 "1"
            ${EndIf}
        ${ElseIf} $R1 == \converter
            ${WordFind} $R0 " " "+2" $R2
            ${WordFind} $R0 " " "+3" $R3
            ${If} $R2 == $\"pdflatex$\"
            ${andIf} $R3 == $\"pdf4$\"
                ;MessageBox MB_OK XELATEX=1
                StrCpy $XELATEX "1"
            ${EndIf}
            ${If} $R2 == $\"eps$\"
            ${andIf} $R3 == $\"png$\"
                ;MessageBox MB_OK EPS2PNG=1
                StrCpy $EPS2PNG "1"
            ${EndIf}
        ${EndIf}
        StrCpy $R9 $R0
        FileWrite $1 $R9
        Goto loop
    next:
    ;MessageBox MB_OK $FORMAT4,$XELATEX,$EPS2PNG
    #${If} "$FORMAT4" == "0"
    #    FileWrite $1 '\format "pdf4" "pdf" "PDF (XeLaTex)" "" "" "" "document,vector"$\r$\n'
    #${EndIf}
    #${If} "$XELATEX" == "0"
    #    FileWrite $1 '\converter "pdflatex" "pdf4" "xelatex $$$$i" "latex"$\r$\n'
    #${EndIf}
    #${If} "$EPS2PNG" == "0"
    #    FileWrite $1 '\converter "eps" "png" "epstopng.bat $$$$i" ""$\r$\n'
    #${EndIf}
    FileClose $0
    FileClose $1
    
    Delete "$EXEDIR\LyX\local\preferences"
    CopyFiles /SILENT "$EXEDIR\LyX\temp.usb" "$EXEDIR\LyX\local\preferences"

    ;Quit
    
    runit:
    
    ####################################################
    
    # run lyx
    ${GetParameters} $1
    IfFileExists "$EXEDIR\LyX\bin\LyX.exe" 0 +3
    Exec '"$EXEDIR\LyX\bin\LyX.exe" $1'
    Goto done
    MessageBox MB_OK "Error: Could not find $EXEDIR\LyX\bin\LyX.exe!"
    done:

SectionEnd
