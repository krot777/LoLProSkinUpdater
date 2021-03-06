
!define AppName "LoLProSkinUpdater"
!define START_MENU "LoL Skin"
!define MUI_ICON "img/lolskin.ico"
!define MUI_UI "form/modern.exe"
!define AppVersion "1.03.01.0"
!define AppDev "by Shen0x440"
!define AppSite "https://github.com/krot777/LoLCS"
!define AppDescription "If you use a program to install skins Skin LoL Pro, League of Legends ,you know that the update it requires you to visit the website LoL Skin and wait to receive download links.With this tool everything will be simple you just need to click the Download(update) you will have updated LoL Skin."

VIProductVersion "${AppVersion}"
VIAddVersionKey ProductName "${AppName}"
VIAddVersionKey ProductVersion "${AppVersion}"
VIAddVersionKey Developer "${AppDev}"
VIAddVersionKey AppWebsite "${AppSite}"
VIAddVersionKey FileVersion "${AppVersion}"
VIAddVersionKey FileDescription "${AppDescription}"
VIAddVersionKey LegalCopyright "Freeware"


XPStyle on
Name "${AppName}"
RequestExecutionLevel admin
OutFile "${AppName}.exe"
SetOverwrite on

;=======include =====
!include "FileFunc.nsh"
!include Sections.nsh
!include MUI2.nsh
!insertmacro MUI_LANGUAGE English


;======Handle variables
Var form_1
Var GroupBox
Var lblAbout
;Var btnExit Disabled exit button
Var btnUnistall
Var btnUpdate
Var btnRun
Var HeaderBMP
Var HeaderBMP_hImage
Var Ena


; dialog create function
Function form_1_Create

  ; === form_1 (type: Dialog) ===
  nsDialogs::Create 1018
  Pop $form_1
  ${If} $form_1 == error
    Abort
  ${EndIf}
  !insertmacro MUI_HEADER_TEXT "Dialog  title..." "Dialog subtitle..."
  ${NSD_CreateGroupBox} 14.48u 59.08u 129.01u 121.85u "LoLSKINUPDATER"
  Pop $GroupBox


  ; === lblAbout (type: Label) ===
  ${NSD_CreateLabel} 57.27u 161.23u 65.82u 8.62u "${AppVersion}"
  Pop $lblAbout
  ${NSD_OnClick} $lblAbout onClickAboutMessage

  ; === btnExit (type: Button) ===
/* ${NSD_CreateButton} 78.33u 122.46u 44.1u 22.15u "EXIT"
  Pop $btnExit
  ${NSD_OnClick} $btnExit onClickExitApp
*/
  ; === btnUnistall (type: Button) ===
  ${NSD_CreateButton} 26.99u 132.31u 96.1u 27.08u "Unistall"
  Pop $btnUnistall
    EnableWindow $btnUnistall $Ena
  ${NSD_OnClick} $btnUnistall onClickUnApp

  ; === btnUpdate (type: Button) ===
  ${NSD_CreateButton} 26.99u 101.54u 96.1u 27.08u "$0"
  Pop $btnUpdate
  ${NSD_OnClick} $btnUpdate onClickUpdate

  ; === btnRun (type: Button) ===
  ${NSD_CreateButton} 26.99u 70.77u 96.1u 27.08u "Run"
  Pop $btnRun
 EnableWindow $btnRun $Ena
  ${NSD_OnClick} $btnRun onClickUpApp

  ${NSD_CreateBitmap} -4.61u -0.62u 219.19u 46.77u ""
  Pop $HeaderBMP

  ${NSD_SetImage} $HeaderBMP "$PLUGINSDIR\header_1.bmp" $HeaderBMP_hImage

  ; === Bitmap1 (type: Bitmap) ===
  ${NSD_CreateBitmap} 7.9u -0.62u 219.19u 46.77u ""
  Pop $HeaderBMP
  File "/oname=$PLUGINSDIR\header_1.bmp" "img\header_1.bmp"
  ${NSD_SetImage} $HeaderBMP "$PLUGINSDIR\header_1.bmp" $HeaderBMP_hImage

FunctionEnd

; dialog show function
Function form_1_Show
  Call form_1_Create
  nsDialogs::Show
FunctionEnd

Function onClickExitApp
Call .onGUIEnd
Call ClearKash
Processes::KillProcess "LoLSKINUPDATER.exe"
Call .onGUIEnd
FunctionEnd

Function onClickUnApp
Call RemoveApp
FunctionEnd

Function onClickUpdate
Call DownloadLOLSkin
Call Writebat
Call Copy
FunctionEnd

Function onClickUpApp
Call Launch
FunctionEnd
Function onClickAboutMessage
MessageBox MB_OK "Build by Shen $\n 14/03/2019 $\n version ${AppVersion}"
FunctionEnd



Function DownloadLOLSkin
  inetc::get /POPUP "" /CAPTION "App.zip" "http://dl2.modskinpro.com/LEAGUESKIN_8.3.zip" "$TEMP\LOLSKIN\App.zip"
    Pop $0 # return value = exit code, "OK" if OK
  ;  MessageBox MB_OK "Download Status: $0"
FunctionEnd

Function "Writebat"

ZipDLL::extractall "$TEMP\LOLSKIN\App.zip" "$TEMP\LOLSKIN"
 ZipDLL::extractall "$TEMP\LOLSKIN\Data.lol" "$TEMP\LOLSKIN"
Delete "$TEMP\LOLSKIN\Data.lol"
Delete "$TEMP\LOLSKIN\App.zip"
Delete "$TEMP\LOLSKIN\*.exe"
FunctionEnd


Function ReBootApp
Processes::KillProcess "LoLSKINUPDATER.exe"
nsExec::Exec "C:\Fraps\${AppName}.exe"
FunctionEnd

Function Copy
CreateDirectory "C:\Fraps"
CopyFiles /SILENT "$TEMP\LOLSKIN\Fraps\*" "C:\Fraps"
CopyFiles /SILENT "$EXEDIR\${AppName}.exe" "C:\Fraps"
;CreateShortCut "$Desktop\LOL Skin.lnk" "C:\Fraps\LOLPRO.exe"
 CreateDirectory "$SMPROGRAMS\${START_MENU}"
CreateShortCut "$SMPROGRAMS\${START_MENU}\LOL Skin.lnk" "C:\Fraps\LOLPRO.exe"
  CreateShortCut "$SMPROGRAMS\${START_MENU}\${AppName}.lnk" "C:\Fraps\${AppName}.exe"

RMdir /r "$TEMP\LOLSKIN\Fraps"
MessageBox MB_OK "Enjoy!"

FunctionEnd


Function RemoveApp
RMdir /r "C:\Fraps"
Delete "$Desktop\LOL Skin.lnk"
RMdir /r "$SMPROGRAMS\${START_MENU}"
MessageBox MB_OK "${AppName} Unistalled!"

FunctionEnd


Function Launch
Exec "C:\Fraps\LOLPRO.exe"
Call onClickExitApp
Call ClearKash

FunctionEnd
; =========================================================
; dialog script ends here
; =========================================================

; show the dialog

  Page custom form_1_Show

Function ClearKash
RMdir /r "$PLUGINSDIR"
RMdir /r "$TEMP"
FunctionEnd


Section main
SectionEnd

Function .onInit

IfFileExists "C:\Fraps\LOLPRO.exe" 0 NotFiles
StrCpy $0 "Update"
StrCpy $Ena "1"
 Goto Done
NotFiles:
StrCpy $0 "Download"
StrCpy $Ena "0"
Done:
CreateDirectory "$TEMP\LOLSKIN"
    InitPluginsDir
   ;Get the skin file to use
     File "/oname=$PLUGINSDIR\header_1.bmp" "img\header_1.bmp"
   File /oname=$PLUGINSDIR\Amakrits.vsf "vcl\CyanNight.vsf"
   ;Load the skin using the LoadVCLStyleA function
   NSISVCLStyles::LoadVCLStyle $PLUGINSDIR\Amakrits.vsf

FunctionEnd
Function .onGUIEnd
 RMdir /r "$PLUGINSDIR"
RMdir /r "$TEMP"
FunctionEnd