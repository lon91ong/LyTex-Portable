Name "LyTeX Suite"
Caption "LyTeX 2.0"
Icon "LyTeX.ico"
OutFile "..\LyTeX-2.3a-bin.exe"

VIProductVersion "2.0.1.0"
VIAddVersionKey  "FileDescription" "LyTeX: Portable TeX Suite"
VIAddVersionKey  "LegalCopyright" "zoho@bbs.ctex.org"
VIAddVersionKey  "FileVersion" "2.3alpha"

!include "LogicLib.nsh"

# Windows Vista settings
RequestExecutionLevel user

# without /solid,archive size will increase by 1/3,
# with /solid, it will need large temp space when extracting
SetCompressor /SOLID lzma
;SetCompressor lzma

AllowRootDirInstall true

InstallDir "D:\LyTeX"

XPStyle on

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"

;Page license
Page directory
Page instfiles

LangString SubCaption2 ${LANG_ENGLISH} " - Extraction Folder"
LangString SubCaption2 ${LANG_SIMPCHINESE} " - ѡ���ѹĿ¼"
SubCaption 2 $(SubCaption2)

LangString DirText1 ${LANG_ENGLISH} "LyTeX will extract to the following folder. To extract it to a different folder, click Browse and select another folder. Click Extract to start the extraction."
LangString DirText1 ${LANG_SIMPCHINESE} "LyTeX ������ѹ�������ļ���. ����Ҫ��ѹ������ͬ���ļ���, �������������ѡ�������ļ���."
LangString DirText4 ${LANG_ENGLISH} "Select the folder to extract LyTeX:"
LangString DirText4 ${LANG_SIMPCHINESE} "��ѡ��Ҫ��ѹ LyTeX ���ļ���λ��:"
DirText $(DirText1) "" "" $(DirText4)

LangString InstallButtonText ${LANG_ENGLISH} "&Extract"
LangString InstallButtonText ${LANG_SIMPCHINESE} "��ѹ(&E)"
InstallButtonText $(InstallButtonText)

BrandingText "zoho@ctex.org"

LangString SubCaption3 ${LANG_ENGLISH} " - Extracting Files"
LangString SubCaption3 ${LANG_SIMPCHINESE} " - ���ڽ�ѹ�ļ�"
SubCaption 3 $(SubCaption3)

ShowInstDetails show

AutoCloseWindow true

Section

    # Can not be omitted
    SetOutPath "$INSTDIR"

    # Warning: must not remove !'s in these two filenames !!!!
    File /a /r /x LyX!.exe /x Setup.exe /x TeXworks!.exe /x About.htm "..\LyTeX\*.*"
    File /a "..\LyTeX\*.*"
    
    # run lytex extraction program
    IfFileExists "$INSTDIR\Setup.exe" 0 +3
    Exec '"$INSTDIR\Setup.exe" install'
    Exec '$INSTDIR\TinyTex\bin\win32\texhash.exe'
    Goto done
    MessageBox MB_OK "Error: Could not find $INSTDIR\Setup.exe!"
    done:

SectionEnd

Function .onInit
   # If language is not Chinese, should change it to Enlish.
   ${If} $LANGUAGE != "2052"
       strcpy $LANGUAGE "1033"
   ${EndIf}
FunctionEnd
