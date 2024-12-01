REM off echo
@echo off
 REM store current path and restore it at the end
 set currentPath=%cd%

rem Default command line args:
set defaultBuildType=SauronRelease
set defaultArch=x64

set root=C:\Users\satbir.singh\source\repos\medmontstudio
set python=C:\Users\satbir.singh\source\repos\Python

if "%1"=="" (set arch=%defaultArch%) else (set arch=%1)
if "%2"=="" (set build_type=%defaultBuildType%) else (set build_type=%2)

if %build_type%==Debug goto build_type_Ok
if %build_type%==Release goto build_type_Ok
if %build_type%==SauronDebug goto build_type_Ok
if %build_type%==SauronRelease goto build_type_Ok

REM echo build type and  arc type
ECHO Invalid arguments: Only accepting x64 or x8 and Debug or Release or SauronDebug or SauronRelease


:build_type_Ok

set bindir=%root%\Studio\CLR\Medmont.Studio.Installer\bin\%arch%\%build_type%

ECHO BINdir set to %bindir%

cd %bindir%

echo Cleaning ..\tmp
mkdir ..\tmp
del /s /f /Q ..\tmp\*.* > nul

echo Saving the minimal set of files to ..\tmp

xcopy /Y /Q Medmont.Studio.Config.xml ..\tmp > nul
xcopy /Y /Q Medmont.Studio.installer.exe ..\tmp > nul
xcopy /Y /Q NuGet.Core.dll ..\tmp > nul

echo Cleaning %bindir%
del /s /f /Q %bindir%\*.* > nul

echo Copying the minimal set of files to %bindir%
xcopy /Y /Q ..\tmp\*.* . > nul

if %build_type%%==Debug goto start_installer
if %build_type%%==Release goto start_installer

REM echo Copying Sauron-specific files not installed by StudioInstaller, to %bindir%:
REM cd %bindir%
REM xcopy /Y /Q /E %root%\E300\Win32\si\PythonEnvironments\*.* .
REM xcopy /Y /Q /E %root%\E300\Win32\si\python\*.* .
REM xcopy /Y /Q /E %root%\E300\Win32\so\%arch%\%build_type%\*.dll .
REM xcopy /Y /Q /E %root%\E300\CLR\Medmont.E300C.ScleralOptics\bin\%arch%\%build_type%\*.dll .
REM xcopy /Y /Q /E %root%\..\ReinstallStudio.Data\*.* .
REM xcopy /Y /Q /E %python%\venv venv\

REM Temporary workaround for invalid Medmont.Studio.Config.xml
REM xcopy /Y /Q %root%\Studio\Config\x64\Medmont.Studio.Config.xml . > nul

:start_installer

cd %bindir%
echo Installing packages from %root%\packages\%build_type%
echo .\Medmont.Studio.Installer.exe /install %root%\packages\%build_type%
.\Medmont.Studio.Installer.exe /install %root%\packages\%build_type%

cd %currentPath%
