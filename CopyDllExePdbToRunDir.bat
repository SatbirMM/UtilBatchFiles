rem v2024-01-25 - don't run this if the calling folder is the Medmont.Studio.Installer
rem v2020.10.27 - handled invalid _TargetPath_ (Medmont.UCRuntime, Medmont.VCRuntime).

set _ConfigurationName_=%CONFIGURATIONNAME%
Set _PlatformTarget_=%PLATFORMTARGET%
set _ProjectName_=%PROJECTNAME%
set _TargetPath_=%TARGETPATH%
set _TargetDir_=%TARGETDIR%
set _TargetName_=%TARGETNAME%
rem set _TargetExt_=%TARGETEXT%

rem - this _TargetPath_ is the main thing (dll or exe) to copy; if invalid, do nothing.
if [%_TargetPath_%]==[] exit 0

if /I "%_ProjectName_%" == "Medmont.Studio.Installer" (
	echo CopyDllExePdbToRunDir doesn't run on Medmont.Studio.Installer project. No action taken
	goto exitall 
)

set _RUN_DIR_1=.\Studio\CLR\Medmont.Studio.Installer\bin\
rem set _RUN_DIR_2=..\ContactLensViewer\ContactLensViewer\bin\
rem set _RUN_DIR_2=..\ExamImageAnalyser\ExamImageAnalyser\bin\
rem set _RUN_DIR_2=..\MeridiaFWUpdater\MeridiaFWUpdater\bin
rem set _RUN_DIR_2=..\StudioDBTester\StudioDBTester\bin\
rem set _RUN_DIR_2=.\Studio\CLR\Medmont.Studio.Console\bin\
 
if [%_RUN_DIR_1%]==[] if [%_RUN_DIR_2%]==[] goto exitall

set _CONF_DIR_=%_PlatformTarget_%\%_ConfigurationName_%

set "_SUB_DIR_="
if %_ProjectName_%==Medmont.DV2000.Alkeria set "_SUB_DIR_=ImageSource\Alkeria"
if %_ProjectName_%==Medmont.DV2000.Alkeria.Installer set "_SUB_DIR_=ImageSource\Alkeria"
if %_ProjectName_%==Medmont.DV2000.CanonED set "_SUB_DIR_=ImageSource\CanonED"
if %_ProjectName_%==Medmont.DV2000.CanonRC set "_SUB_DIR_=ImageSource\CanonRC"
if %_ProjectName_%==Medmont.DV2000.Inami set "_SUB_DIR_=ImageSource\Inami"
if %_ProjectName_%==Medmont.DV2000.Keeler set "_SUB_DIR_=ImageSource\Keeler"
if %_ProjectName_%==Medmont.DV2000.Keeler.Forms set "_SUB_DIR_=ImageSource\Keeler"
if %_ProjectName_%==Medmont.DV2000.NikonD100 set "_SUB_DIR_=ImageSource\NikonD100"
if %_ProjectName_%==Medmont.DV2000.SunKingdom set "_SUB_DIR_=ImageSource\SunKingdom"

if %_ProjectName_%==Medmont.Video.Artray set "_SUB_DIR_=Video\Artray"
if %_ProjectName_%==Medmont.Video.AVT set "_SUB_DIR_=Video\AVT"
if %_ProjectName_%==Medmont.Video.AVT.Installer set "_SUB_DIR_=Video\AVT"
if %_ProjectName_%==Medmont.Video.E300 set "_SUB_DIR_=Video\E300"
if %_ProjectName_%==Medmont.Video.E300C.uEye set "_SUB_DIR_=Video\E300C.uEye"
if %_ProjectName_%==Medmont.Video.E300C.uEye.Forms set "_SUB_DIR_=Video\E300C.uEye"
if %_ProjectName_%==Medmont.Video.FlashBus set "_SUB_DIR_=Video\FlashBus"
if %_ProjectName_%==Medmont.Video.Leutron set "_SUB_DIR_=Video\Leutron"
if %_ProjectName_%==Medmont.Video.Leutron.Installer set "_SUB_DIR_=Video\Leutron"
if %_ProjectName_%==Medmont.Video.Picolo set "_SUB_DIR_=Video\Picolo"
if %_ProjectName_%==Medmont.Video.PointGrey set "_SUB_DIR_=Video\PointGrey"
if %_ProjectName_%==Medmont.Video.PointGrey.Installer set "_SUB_DIR_=Video\PointGrey"
if %_ProjectName_%==Medmont.Video.uEye.Installer set "_SUB_DIR_=Video\uEye"
if %_ProjectName_%==Medmont.Video.E300C.Peak set "_SUB_DIR_=Video\E300C.Peak"
if %_ProjectName_%==Medmont.Video.Peak set "_SUB_DIR_=Video\E300C.Peak"
rem echo _SUB_DIR_  "%_SUB_DIR_%"


echo ___________________________________________________________________________________________________
echo CopyDllExePdbToRunDir.bat                                   %_ProjectName_%

@rem If we encounter script errors (such as failure to copy) then keep track of that
@rem   for exit status.
set /a scriptError = 0

:RUN_DIR_1
if [%_RUN_DIR_1%]==[] goto RUN_DIR_2

set _DES_DIR_1=%_RUN_DIR_1%\%_CONF_DIR_%\%_SUB_DIR_%
if not exist "%_DES_DIR_1%" mkdir "%_DES_DIR_1%"

echo Run directory                                               %_RUN_DIR_1%
echo Destination                                                 %_DES_DIR_1%

echo.
xcopy /Y %_TargetPath_% %_DES_DIR_1%
if %ERRORLEVEL% NEQ 0 set /A scriptError=%ERRORLEVEL%


if %_ConfigurationName_%==Debug xcopy /Y %_TargetDir_%%_TargetName_%.pdb %_DES_DIR_1%

@rem below chunk just to print normalised _des_dir_ without '..\' etc.
set _CD_OLD_=%CD%
cd %_DES_DIR_1%
echo ```````````````` to: %CD%   ::1::
cd %_CD_OLD_%


:RUN_DIR_2
if [%_RUN_DIR_2%]==[] goto FINISH_LINE

set _DES_DIR_2=%_RUN_DIR_2%\%_CONF_DIR_%\%_SUB_DIR_%
if not exist "%_DES_DIR_2%" mkdir "%_DES_DIR_2%"

echo Run directory                                               %_RUN_DIR_2%
echo Destination                                                 %_DES_DIR_2%

echo.
xcopy /Y %_TargetPath_% %_DES_DIR_2%
if %ERRORLEVEL% NEQ 0 set /A scriptError=%ERRORLEVEL%


if %_ConfigurationName_%==Debug xcopy /Y %_TargetDir_%%_TargetName_%.pdb %_DES_DIR_2%
if %ERRORLEVEL% NEQ 0 set /A scriptError=%ERRORLEVEL%


@rem below chunk just to print normalised _des_dir_ without '..\' etc.
set _CD_OLD_=%CD%
cd %_DES_DIR_2%
echo ```````````````` to: %CD%   ::2::
cd %_CD_OLD_%


:FINISH_LINE
echo ___________________________________________________________________________________________________

:exitall

exit /b %scriptError%

