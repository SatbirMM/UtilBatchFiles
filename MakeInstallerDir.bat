@echo off

set root=%cd%\medmontstudio
set VBoxShared=d:\workspace\VirtualBox Shared

if "%1"=="" (set arch=x64) else (set arch=%1)
if "%2"=="" (set build_type=SauronRelease) else (set build_type=%2)

if %build_type%==Debug goto build_type_Ok
if %build_type%==Release goto build_type_Ok
if %build_type%==SauronDebug goto build_type_Ok
if %build_type%==SauronRelease goto build_type_Ok
echo Invalid build type
exit 1
:build_type_Ok

echo Making installer directory for %arch% %build_type%
echo ----------------------------------------
set destination=C:\Users\%username%\Desktop\Installer.%build_type%.%arch%

rem rmdir /s /f .\tmp
mkdir .\tmp > nul

set CWD=%cd%
set InstallerRunDir=%root%\Studio\CLR\Medmont.Studio.Installer\bin\%arch%\%build_type%
set LogFile=%CWD%\logs\_CleanInstallerDir.log

echo Copy Studio installer files from %InstallerRunDir%

xcopy /Y /Q %InstallerRunDir%\Medmont.Studio.Config.xml .\tmp > nul
xcopy /Y /Q %InstallerRunDir%\Medmont.Studio.installer.* .\tmp > nul
xcopy /Y /Q %InstallerRunDir%\NuGet.Core.dll .\tmp > nul

del /S /F /Q %InstallerRunDir%\*.* > nul

xcopy /Y /Q .\tmp\*.* %InstallerRunDir% > nul

rmdir /S /Q %destination%

echo Copy Studio packages
mkdir %destination%
mkdir %destination%\bin
mkdir %destination%\packages
xcopy /Y /Q %root%\packages\%build_type%\*%arch%*.* %destination%\packages > nul
xcopy /Y /Q %InstallerRunDir%\*.* %destination%\bin > nul

if %build_type%==Debug (
   echo Copy Debug VCRT DLLs
   xcopy /Y /Q \workspace\VCRT\%arch%\*.dll %destination%\bin > nul
   xcopy /Y /Q \workspace\UCRT\%arch%\*.dll %destination%\bin > nul
)

echo cd bin > %destination%\install.bat
echo .\Medmont.Studio.Installer.exe /install ../packages >> %destination%\install.bat

set InstallerDir=%VBoxShared%\Installer.%build_type%.%arch%
echo Copy Everything to "%InstallerDir%"
rmdir /S/Q "%InstallerDir%"
mkdir "%InstallerDir%"
xcopy /S /Q %destination% "%InstallerDir%" > nul

echo Done
