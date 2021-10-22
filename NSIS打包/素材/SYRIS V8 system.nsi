; 該指令檔使用 HM VNISEdit 指令檔編輯器精靈產生

; 安裝程式初始定義常量
!define PRODUCT_NAME "SYRIS V8 system";jash modify
!define PRODUCT_VERSION "v0274";jash modify
!define PRODUCT_PUBLISHER "SYRIS, Inc.";jash modify
!define PRODUCT_WEB_SITE "http://www.syris.com/";jash modify
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\syws.exe";jash modify
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
BrandingText "Provided by SYRIS, Inc."  # 設置UI分割線上的文字。

SetCompressor /SOLID lzma

; ------ MUI 現代介面定義 (1.67 版本以上相容) ------
!include "MUI.nsh"


; MUI 預定義常量
!define MUI_ABORTWARNING
!define MUI_ICON "Release\SYWEB-icon_100x100.ico";jash modify
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; 語言選擇視窗常量設定
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; 歡迎頁面
!insertmacro MUI_PAGE_WELCOME
; 授權合約頁面
;!insertmacro MUI_PAGE_LICENSE "..\..\..\path\to\licence\YourSoftwareLicence.txt"
; 安裝資料夾選擇頁面
!insertmacro MUI_PAGE_DIRECTORY
; 安裝過程頁面
!insertmacro MUI_PAGE_INSTFILES
; 安裝完成頁面
;!define MUI_FINISHPAGE_RUN "$INSTDIR\BCard_WCard_Generator.exe"
!insertmacro MUI_PAGE_FINISH

; 安裝卸載過程頁面
!insertmacro MUI_UNPAGE_INSTFILES

; 安裝介麵包含的語言設定
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"

; 安裝預釋放檔案
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 現代介面定義結束 ------

ReserveFile "${NSISDIR}\Plugins\splash.dll"
;ReserveFile "c:\path\to\Splash\YourSplash.bmp"
;ReserveFile "c:\path\to\Splash\YourSplashSound.wav"

ReserveFile "${NSISDIR}\Plugins\system.dll"
;ReserveFile "c:\path\to\YourMIDI.mid"

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} ${PRODUCT_VERSION}.exe";jash modify
InstallDir "C:\SYRIS\Workstation";jash modify-因應有MySQL，所以已把安裝目錄放在C槽下，原本~ InstallDir "$PROGRAMFILES\SYRIS Workstation"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOverwrite on

  
  SetOutPath "$INSTDIR"
  
  File "Release\cg01.bat";jash modify
  IfFileExists "C:\SYRIS\sycg\bin\uninsts.bat" AutoexecExists PastAutoexecCheck
  AutoexecExists:
  ExecWait "$INSTDIR\cg01.bat";jash modify
	 
  PastAutoexecCheck:  
  CreateDirectory "$SMPROGRAMS\SYRIS Workstation";jash modify
  CreateShortCut "$SMPROGRAMS\SYRIS Workstation\SYRIS Workstation.lnk" "$INSTDIR\syws.exe";jash modify
  CreateShortCut "$DESKTOP\SYRIS Workstation.lnk" "$INSTDIR\syws.exe";jash modify

  File "Release\syws.exe";jash modify
  File "Release\deb.zip";jash modify~其他檔案全部壓成同一個ZIP這樣就不用寫太多
  File "Release\vcredist_x86.exe";jash modify
  File "Release\NDP472-KB4054530-x86-x64-AllOS-ENU.exe";jash modify
  File "Release\sycg-i386-win32-0.9.18.0496-2021102202-installer.exe";jash modify
  File "Release\cg.bat";jash modify
  File "Release\安裝ODBC驅動程式-20201130.pdf";jash modify
  File "Release\SYSOFT-TAM_V8_Setup_2020-12-04.exe"
  File "Release\MySQL_ODBC51.reg";	File "Release\SYSyncMySQL-V8.exe";jash modify
  File "Release\mysql-connector-odbc-5.1.5-winx64.msi";jash modify
  File "Release\SyrisPIDCIDInput.exe";jash modify
  ;File "Release\NDP452-KB2901907-x86-x64-AllOS-ENU.exe";jash modify
  ;File "Release\NDP47-KB3186497-x86-x64-AllOS-ENU.exe";jash modify
  
  ;使用外掛元件執行解壓縮
  nsisunz::UnzipToLog "$INSTDIR\deb.zip" $INSTDIR
  Delete "$INSTDIR\deb.zip";jash modify
  
  ExecWait "$INSTDIR\vcredist_x86.exe /q";jash modify
  ExecWait "$INSTDIR\NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
  
  ExecWait "$INSTDIR\SYSOFT-TAM_V8_Setup_2020-12-04.exe"
  
  IfFileExists "C:\Program Files\MySQL\Connector ODBC 5.1\myodbc5.dll" ODBCSetting InstallODBC
  ODBCSetting:
  ExecWait "regedit.exe $INSTDIR\MySQL_ODBC51.reg"
  goto end_of_ODBC ;<== important for not continuing on the else branch 
  InstallODBC:
  ExecWait '"msiexec" /i "$INSTDIR\mysql-connector-odbc-5.1.5-winx64.msi"'
  ExecWait "regedit.exe $INSTDIR\MySQL_ODBC51.reg"
  end_of_ODBC: 
  ;ExecWait "$INSTDIR\SYSyncMySQL-V8.exe"
  
  
  ExecWait "$INSTDIR\sycg-i386-win32-0.9.18.0496-2021102202-installer.exe"
  ExecWait "$INSTDIR\SyrisPIDCIDInput.exe";jash modify
  ExecWait "$INSTDIR\cg.bat";jash modify
  
  CopyFiles "$INSTDIR\安裝ODBC驅動程式-20201130.pdf" "C:\Program Files (x86)\SYSOFT-TAM"

  Delete "$INSTDIR\sycg-i386-win32-0.9.18.0496-2021102202-installer.exe";jash modify
  Delete "$INSTDIR\vcredist_x86.exe";jash modify
  Delete "$INSTDIR\NDP472-KB4054530-x86-x64-AllOS-ENU.exe";jash modify
  Delete "$INSTDIR\cg.bat";jash modify
  Delete "$INSTDIR\cg01.bat";jash modify
  Delete "$INSTDIR\SyrisPIDCIDInput.exe";jash modify
  Delete "$INSTDIR\安裝ODBC驅動程式-20201130.pdf";jash modify
  Delete "$INSTDIR\SYSOFT-TAM_V8_Setup_2020-12-04.exe";jash modify
  Delete "$INSTDIR\mysql-connector-odbc-5.1.5-winx64.msi";jash modify
  Delete "$INSTDIR\MySQL_ODBC51.reg" ;Delete "$INSTDIR\SYSyncMySQL-V8.exe";jash modify
  
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\SYRIS Workstation\Website.lnk" "$INSTDIR\Website.url";jash modify
  CreateShortCut "$SMPROGRAMS\SYRIS Workstation\Uninstall.lnk" "$INSTDIR\uninst.exe";jash modify
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\syws.exe";jash modify
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\syws.exe";jash modify
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

#-- 依 NSIS 指令檔編輯規則，所有 Function 區段必須放置在 Section 區段之後編寫，以避免安裝程式出現未可預知的問題。--#

Function .onInit
  InitPluginsDir
  ;File "/oname=$PLUGINSDIR\Splash_YourSplash.bmp" "c:\path\to\Splash\YourSplash.bmp"
  ;File "/oname=$PLUGINSDIR\Splash_YourSplash.wav" "c:\path\to\Splash\YourSplashSound.wav"
  ; 使用閃屏外掛程式顯示閃屏
  splash::show 1000 "$PLUGINSDIR\Splash_YourSplash"
  Pop $0 ; $0 返回 '1' 表示使用者提前關閉閃屏, 返回 '0' 表示閃屏正常結束, 返回 '-1' 表示閃屏顯示出錯
  ;File "/oname=$PLUGINSDIR\bgm_YourMIDI.mid" "c:\path\to\YourMIDI.mid"
  ; 開啟音樂檔案
  System::Call "winmm.dll::mciSendString(t 'OPEN $PLUGINSDIR\bgm_YourMIDI.mid TYPE SEQUENCER ALIAS BGMUSIC', t .r0, i 130, i 0)"
  ; 開始播放音樂檔案
  System::Call "winmm.dll::mciSendString(t 'PLAY BGMUSIC NOTIFY', t .r0, i 130, i 0)"
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onGUIEnd
  ; 停止播放音樂檔案
  System::Call "winmm.dll::mciSendString(t 'STOP BGMUSIC',t .r0,i 130,i 0)"
  ; 關閉音樂檔案
  System::Call "winmm.dll::mciSendString(t 'CLOSE BGMUSIC',t .r0,i 130,i 0)"
FunctionEnd

/******************************
 *  以下是安裝程式的卸載部分  *
 ******************************/

Section Uninstall

  Delete "$DESKTOP\SYRIS Workstation.lnk";jash modify

  
  RMDir /r "$INSTDIR\*.*"
  RMDir "$INSTDIR"
  
  RMDir /r "$SMPROGRAMS\SYRIS Workstation\*.*";jash modify
  RMDir "$SMPROGRAMS\SYRIS Workstation";jash modify  
  
  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\SYRIS Workstation\*.*";jash modify
  RMDir "$SMPROGRAMS\SYRIS Workstation";jash modify


  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd

#-- 依 NSIS 指令檔編輯規則，所有 Function 區段必須放置在 Section 區段之後編寫，以避免安裝程式出現未可預知的問題。--#

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確實要完全移除 $(^Name) ，及其所有的元件？" IDYES +2
  Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地從你的電腦移除。";MessageBox MB_ICONINFORMATION|MB_OK "PC reboot now"
  ;Reboot
FunctionEnd
