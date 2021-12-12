@echo off

set IMGID=%1
set IMGID=1
set IMGID=2
set IMGID=3
set IMGID=4
set IMGID=5

PATH=C:\Program Files\qemu;%PATH%

if "%IMGID%"=="1" (set VMNAME=kubuntu-16.04.5-desktop-amd64)          & (set VMPORT=5555)
if "%IMGID%"=="2" (set VMNAME=kubuntu-18.04.2-desktop-amd64)          & (set VMPORT=5556)
if "%IMGID%"=="3" (set VMNAME=en_windows_10_enterprise_ltsc_2019_x64) & (set VMPORT=5557)
if "%IMGID%"=="4" (set VMNAME=kubuntu_20.04.2.0_desktop_amd64)        & (set VMPORT=5558)
if "%IMGID%"=="5" (set VMNAME=ubuntu_20.04.2.0_desktop_amd64)         & (set VMPORT=5559)
if [%VMNAME%] == [] GOTO error2

set FILENAME=D:\root\qemu\%VMNAME%

rem  -monitor stdio  -cpu host kvm
set COMMAND=-machine accel=hax -smp 4 -m 4096 -no-fd-bootchk -hda %FILENAME% -boot order=c,menu=off -device e1000,netdev=user.0 -netdev user,id=user.0,hostfwd=tcp::%VMPORT%-:%VMPORT% -rtc base=localtime -name %VMNAME% -snapshot

@echo qemu-system-x86_64 %COMMAND%

@echo *** RUN ***
rem qemu-system-x86_64 %COMMAND%
if %ERRORLEVEL% NEQ 0 GOTO error
@echo *** EXIT ***

pause
exit 0

:error
    @echo qemu-system-x86_64 Failed [%ERRORLEVEL%]
    pause
    exit 1
	
:error2
	@echo ***** VM id out of range. Abort.
    pause
	exit 2