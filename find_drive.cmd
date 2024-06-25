@echo off
:: Finds the first drive (alphabetical order) with a given volumename and (optional) type.
::
 
:check parameters
if [%1]==[] goto usage
set drive_volumename=%1
if [%2]==[] goto find_without_type
goto find_with_type

:find_with_type
set drive_type=%2
for /F "usebackq tokens=1 skip=1" %%i in (`wmic logicaldisk where ^(DriveType^=%drive_type% and VolumeName^=%drive_volumename%^) get caption^,drivetype 2^>NUL`) do (
  if exist %%i (
     set DRIVE_FOUND=%%i
     goto found
  )
)
goto not-found

:find_without_type
for /F "usebackq tokens=1 skip=1" %%i in (`wmic logicaldisk where ^(VolumeName^=%drive_volumename%^) get caption^,drivetype 2^>NUL`) do (
  if exist %%i (
     set DRIVE_FOUND=%%i
     goto found
  )
)
goto not-found

:usage
echo.
echo Finds the first drive (alphabetical order) with a given volumename and (optional) type. 
echo The result will be returned as %%DRIVE_FOUND%%. It will be "" when nothing was found.
echo.
echo USAGE: %~n0 [name] ([type])
echo.
echo NOTE: type is optional:
echo.
echo       0 = Unknown
echo       1 = No Root Directory
echo       2 = Removable Disk
echo       3 = Local Disk
echo       4 = Network Drive
echo       5 = Compact Disc
echo       6 = RAM Disk
echo.
echo       See also: 'wmic logicaldisk'
echo.
goto not-found

:found
::echo %DRIVE_FOUND%
set drive_volumename=
set drive_type=
exit /b 0

:not-found
set DRIVE_FOUND=""
set drive_volumename=
set drive_type=
exit /b 1