Name "LyTeX Setup"
Caption "LyTeX"
Icon "Setup.ico"
OutFile "..\LyTeX\Setup.exe"

# Windows Vista settings
RequestExecutionLevel user

SetCompressor /SOLID lzma

!include "LogicLib.nsh"

!include "FileFunc.nsh"
!insertmacro RefreshShellIcons
!insertmacro GetParameters

!include InstallOptions.nsh

Var /Global RealLang

XPStyle on

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
;LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"

LangString CustomPage ${LANG_ENGLISH} " - Choose Operation"
LangString CustomPage ${LANG_SIMPCHINESE} " - ѡ������Ĳ���"

;Page "license"
Page custom customPage "" $(CustomPage)
Page "components"
;Page "directory"
Page "instfiles"

LangString ChooseJob ${LANG_ENGLISH} "Please select what you want to do:"
LangString ChooseJob ${LANG_SIMPCHINESE} "��ѡ������Ҫ�������ã�"

LangString SetupTeX ${LANG_ENGLISH} "Change installable or portable type"
LangString SetupTeX ${LANG_SIMPCHINESE} "�ı䰲װ�����ɫ������"

LangString UpdateLyX ${LANG_ENGLISH} "Update to latest LyX from internet"
LangString UpdateLyX ${LANG_SIMPCHINESE} "�������� LyX �����°汾"

LangString UpdateTeX ${LANG_ENGLISH} "Manage or update TeX programs and packages"
LangString UpdateTeX ${LANG_SIMPCHINESE} "��������� TeX ����ͺ��"

Function customPage

   # skip this page when installing
   ${GetParameters} $0
   ${If} $0 == "install"
      Abort
   ${EndIf}

   !insertmacro INSTALLOPTIONS_WRITE "Setup.ini" "Field 1" "Text" $(ChooseJob)
   !insertmacro INSTALLOPTIONS_WRITE "Setup.ini" "Field 2" "Text" $(SetupTeX)
   !insertmacro INSTALLOPTIONS_WRITE "Setup.ini" "Field 3" "Text" $(UpdateLyX)
   !insertmacro INSTALLOPTIONS_WRITE "Setup.ini" "Field 4" "Text" $(UpdateTeX)
      
   !insertmacro INSTALLOPTIONS_DISPLAY "Setup.ini"
   # Update LyX
   !insertmacro INSTALLOPTIONS_READ $R2 "Setup.ini" "Field 3" "State"
   ;MessageBox MB_OK "$R2"
   StrCmp $R2 "1" 0 tex
   Exec "$EXEDIR\Common\update\update.bat"
   Quit
   tex:
   # Update TeX
   !insertmacro INSTALLOPTIONS_READ $R3 "Setup.ini" "Field 4" "State"
   ;MessageBox MB_OK "$R3"
   StrCmp $R3 "1" 0 default
   ${If} $%buildtex% == "texlive"
   Exec '"$EXEDIR\TinyTeX\texshell.bat" texmgr'
   ${Else} ## miktex
   Exec '"$EXEDIR\MiKTeX\texshell.bat" texmgr'
   ${EndIf}
   Quit
   # Setup TeX
   default:
FunctionEnd

LangString SubCaption1 ${LANG_ENGLISH} " - Choose Operations"
LangString SubCaption1 ${LANG_SIMPCHINESE} " - ѡ��װ����"
SubCaption 1 $(SubCaption1)

LangString InstallableType ${LANG_ENGLISH} "Installable Type"
LangString InstallableType ${LANG_SIMPCHINESE} "��װ��"
InstType $(InstallableType)

LangString PortableType ${LANG_ENGLISH} "Portable Type"
LangString PortableType ${LANG_SIMPCHINESE} "��ɫ��"
InstType $(PortableType)

InstType /NOCUSTOM

LangString ComponentText1 ${LANG_ENGLISH} "$\r$\nYou can install LyTeX to system, or make it portable"
LangString ComponentText1 ${LANG_SIMPCHINESE} "$\r$\nLyTeX �ȿ��԰�װ���û�ϵͳ, Ҳ���Ա���ԭ�е���ɫ��."

LangString ComponentText2 ${LANG_ENGLISH} "Select installable or portable"
LangString ComponentText2 ${LANG_SIMPCHINESE} "ѡ�񣢰�װ�棢����ɫ�棢"

LangString ComponentText3 ${LANG_ENGLISH} "$\r$\n$\r$\nInstallable: for installing or repairing LyTeX.$\r$\n$\r$\nPortable: for portablizing or removing LyTeX."
LangString ComponentText3 ${LANG_SIMPCHINESE} "$\r$\n$\r$\n��װ��:���ڰ�װ���޸�LyTeX.$\r$\n$\r$\n��ɫ��:�����̻���ɾ��LyTeX."

ComponentText "$(ComponentText1)" "$(ComponentText2)" "$(ComponentText3)"


;LangString MiscButtonText4 ${LANG_ENGLISH} "OK"
;LangString MiscButtonText4 ${LANG_SIMPCHINESE} "ȷ��"
;MiscButtonText "" "" "" $(MiscButtonText4)

LangString InstallButtonText ${LANG_ENGLISH} "OK"
LangString InstallButtonText ${LANG_SIMPCHINESE} "ȷ��"
InstallButtonText $(InstallButtonText)

BrandingText "zoho@ctex.org"
SpaceTexts none

LangString SubCaption3 ${LANG_ENGLISH} " - Make Operations"
LangString SubCaption3 ${LANG_SIMPCHINESE} " - ���ڽ�������"
SubCaption 3 $(SubCaption3)

ShowInstDetails show

AutoCloseWindow true


LangString SectionA ${LANG_ENGLISH} "Add shortcuts to desktop"
LangString SectionA ${LANG_SIMPCHINESE} "��ӿ�ݷ�ʽ���û�����"
Section $(SectionA) SEC-A
# in other language SectionA will be empty
# but section with empty name will be hidden!

SectionIn 1

;SectionSetText ${SEC-A} $(SectionA)

CreateShortCut "$DESKTOP\LyX.lnk" "$EXEDIR\LyX!.exe"
CreateShortCut "$DESKTOP\TeXworks.lnk" "$EXEDIR\TeXworks!.exe"
${If} $LANGUAGE == "2052"
${orIf} $RealLang == "1028"
    CreateShortCut "$DESKTOP\LyTeX.lnk" "$EXEDIR\Manual\chinese\lytex.pdf"
${EndIf}
SectionEnd

LangString PortableSuite ${LANG_ENGLISH} " Portable Suite"
LangString PortableSuite ${LANG_SIMPCHINESE} " ��ɫ��װ"
LangString SectionB ${LANG_ENGLISH} "Add shortcuts to start menu"
LangString SectionB ${LANG_SIMPCHINESE} "��ӿ�ݷ�ʽ����ʼ�˵�"
Section $(SectionB)
SectionIn 1

CreateDirectory "$SMPROGRAMS\LyTeX$(PortableSuite)"
CreateShortCut "$SMPROGRAMS\LyTeX$(PortableSuite)\LyX.lnk" "$EXEDIR\LyX!.exe"
CreateShortCut "$SMPROGRAMS\LyTeX$(PortableSuite)\TeXworks.lnk" "$EXEDIR\TeXworks!.exe"
CreateShortCut "$SMPROGRAMS\LyTeX$(PortableSuite)\Setup.lnk" "$EXEDIR\Setup.exe"
CreateShortCut "$SMPROGRAMS\LyTeX$(PortableSuite)\About.lnk" "$EXEDIR\About.htm"
${If} $LANGUAGE == "2052" ; 2052 for Simplified Chinese
${orIf} $RealLang == "1028" ; 1028 for Traditional Chinese
    CreateShortCut "$SMPROGRAMS\LyTeX$(PortableSuite)\LyTeX.lnk" "$EXEDIR\Manual\chinese\lytex.pdf"
${EndIf}
SectionEnd

LangString SectionC ${LANG_ENGLISH} "Open .lyx file using LyX"
LangString SectionC ${LANG_SIMPCHINESE} "Ĭ���� LyX ��.lyx �ļ�"
Section $(SectionC)
SectionIn 1

WriteRegStr HKCU "Software\Classes\.lyx" "" "LyX.LyTeX"
WriteRegStr HKCU "Software\Classes\LyX.LyTeX" "" "LyX Document"
WriteRegStr HKCU "Software\Classes\LyX.LyTeX\shell\open\command" "" '$EXEDIR\LyX!.exe "%1"'
WriteRegStr HKCU "Software\Classes\LyX.LyTeX\DefaultIcon" "" "$EXEDIR\LyX!.exe,0"

${RefreshShellIcons}

SectionEnd

LangString SectionD ${LANG_ENGLISH} "Open .tex file using TeXworks"
LangString SectionD ${LANG_SIMPCHINESE} "Ĭ���� TeXworks �� .tex �ļ�"
Section $(SectionD)
SectionIn 1

WriteRegStr HKCU "Software\Classes\.tex" "" "TeX.LyTeX"
WriteRegStr HKCU "Software\Classes\TeX.LyTeX" "" "TeX Document"
WriteRegStr HKCU "Software\Classes\TeX.LyTeX\shell\open\command" "" '$EXEDIR\TeXworks!.exe "%1"'
WriteRegStr HKCU "Software\Classes\TeX.LyTeX\DefaultIcon" "" "$EXEDIR\TeXworks!.exe,0"

${RefreshShellIcons}

SectionEnd

#LangString SectionE ${LANG_ENGLISH} "Open .pdf file using TeXworks"
#LangString SectionE ${LANG_SIMPCHINESE} "Ĭ���� TeXworks �� .pdf �ļ�"
#Section /o $(SectionE)
#SectionEnd

LangString SectionH ${LANG_ENGLISH} "Remove all shortcuts and opentypes"
LangString SectionH ${LANG_SIMPCHINESE} "ɾ�����п�ݷ�ʽ�ʹ򿪷�ʽ"
Section -$(SectionH)
SectionIn 2

Delete "$DESKTOP\LyX.lnk"
Delete "$DESKTOP\TeXworks.lnk"
Delete "$DESKTOP\LyTeX.lnk"

RMDir /r "$SMPROGRAMS\LyTeX$(PortableSuite)"
DeleteRegValue HKCU "Software\Classes\.lyx" ""
DeleteRegKey HKCU "Software\Classes\LyX.LyTeX"
DeleteRegValue HKCU "Software\Classes\.tex" ""
DeleteRegKey HKCU "Software\Classes\TeX.LyTeX"
${RefreshShellIcons}

SectionEnd


Function .onInit

    # If language is not Chinese, should change it to Enlish.
    ${If} $LANGUAGE != "2052"
        strcpy $RealLang $LANGUAGE
        strcpy $LANGUAGE "1033"
    ${EndIf}

    !insertmacro INSTALLOPTIONS_EXTRACT "Setup.ini"

    # Detect LyX version
    # ??? take no effect when LyX20.exe exists
    /*
    StrCpy $LYXDIR "LyX16"
    IfFileExists "$EXEDIR\LyX20\bin\lyx!.exe" 0 donever
       StrCpy $LYXDIR "LyX20"
       Goto donever
    IfFileExists "$EXEDIR\LyX21" 0 donever
       StrCpy $LYXDIR "LyX21"
       Goto donever
    donever:
    MessageBox MB_OK "$LYXDIR"
    */
FunctionEnd
