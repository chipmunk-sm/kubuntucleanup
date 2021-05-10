#!/bin/sh

# $qemu-img convert -c -O qcow2 /media/${USER}/Data/root/qemu/kubuntu-16.04.5-desktop-amd64          /media/${USER}/Data/root/qemu/kubuntu-16.04.5-desktop-amd64_1
# $qemu-img convert -c -O qcow2 /media/${USER}/Data/root/qemu/kubuntu-18.04.2-desktop-amd64          /media/${USER}/Data/root/qemu/kubuntu-18.04.2-desktop-amd64_1
# $qemu-img convert -c -O qcow2 /media/${USER}/Data/root/qemu/en_windows_10_enterprise_ltsc_2019_x64 /media/${USER}/Data/root/qemu/en_windows_10_enterprise_ltsc_2019_x64_1
# $qemu-img convert -c -O qcow2 /media/${USER}/Data/root/qemu/kubuntu_20.04.2.0_desktop_amd64        /media/${USER}/Data/root/qemu/kubuntu_20.04.2.0_desktop_amd64_1
# $qemu-img convert -c -O qcow2 /media/${USER}/Data/root/qemu/ubuntu_20.04.2.0_desktop_amd64         /media/${USER}/Data/root/qemu/ubuntu_20.04.2.0_desktop_amd64_1

# **** example. 
# prepare VM, Host for remote control

# $ sudo apt install openssh-server
# $ sudo apt install mc

# Enable password, disable pubkey authentication for ssh server (sshd)
# * /etc/ssh/sshd_config
# * set 'PasswordAuthentication yes'
# * set 'PubkeyAuthentication no'
# * Change sshd port, set same as startup config for VM or HOST (SSH_PORT 5xxxx)

# ufw allow ssh port
# $ sudo ufw allow SSH_PORT

# restart sshd
# $ sudo systemctl restart sshd.service

# VM
# $ ssh buildvm@127.0.0.1 -p 5555 'mkdir -p ~/.ssh'
# $ cat ~/.ssh/buildvm@buildvm.pub | ssh buildvm@127.0.0.1 -p 5555 'cat >> ~/.ssh/authorized_keys'
# $ ssh buildvm@127.0.0.1 -p 5555 'chmod 600 ~/.ssh/authorized_keys'
# $ ssh buildvm@127.0.0.1 -p 5555 'chmod 700 ~/.ssh'

# VM (windows)
# $ ssh build10a@127.0.0.1 -p 5557 'mkdir -p ~/.ssh'
# $ scp -P 5557 /home/f/.ssh/build10a@win10Lts2019.pub build10a@127.0.0.1:C:\Users\build10a\.ssh\


# HOST
# $ ssh build@build.com -p 60021 'mkdir -p ~/.ssh'
# $ cat ~/.ssh/build@build.pub | ssh build@build.com -p 60021 'cat >> ~/.ssh/authorized_keys'
# $ ssh build@build.com -p 60021 'chmod 600 ~/.ssh/authorized_keys'
# $ ssh build@build.com -p 60021 'chmod 700 ~/.ssh'

# Disable password, enable pubkey authentication for ssh server (sshd)
# *** /etc/ssh/sshd_config
# *** set 'PasswordAuthentication no'
# *** set 'PubkeyAuthentication yes'

# restart sshd
# $ sudo systemctl restart sshd.service

# copy key for ssh from HOST to VM
# $ scp -P 60021 ~/.ssh/buildvm@buildvm.pub build@build.com:~/.ssh/
# $ scp -P 60021 ~/.ssh/buildvm@buildvm build@build.com:~/.ssh/
# $ ssh build@build.com -p 60021 'chmod 644 ~/.ssh/buildvm@buildvm.pub'
# $ ssh build@build.com -p 60021 'chmod 600 ~/.ssh/buildvm@buildvm'

# ***************************************
# Create an ssh tunnel, connect to the VNC Desktop
# ssh build@build.com -p 60021  -C  -L 5901:127.0.0.1:5901

# ***************************************+
# ssh build1604a@127.0.0.1 -p 5555
# ssh build1804a@127.0.0.1 -p 5556
# ssh win10ltsc64@127.0.0.1 -p 5557
# ssh build2004a@127.0.0.1 -p 5558
# ssh build2004u@127.0.0.1 -p 5559

# ***************************************

# copy from VM to HOST
# $ scp -P 5559 build2004u@127.0.0.1:/home/build2004u/Downloads/archive.zip /home/${USER}/Downloads/

# copy from HOST to VM
# $ scp -P 5559 /home/${USER}/Downloads/archive.zip build2004u@127.0.0.1:/home/build2004u/Downloads/

mainPid=$$

#+ configuration

# run VM from command line

#kubuntu-16.04.5-desktop-amd64
#./run_vm.sh 1

#kubuntu-18.04.2-desktop-amd64
#./run_vm.sh 2

#en_windows_10_enterprise_ltsc_2019_x64
#./run_vm.sh 3

#kubuntu_20.04.2.0_desktop_amd64
#./run_vm.sh 4

#ubuntu_20.04.2.0_desktop_amd64
#./run_vm.sh 5

imgID=$1

# monitorType="-monitor stdio"

#   enable or disable snapshot Mode
QEMU_SNAPSHOT_MODE="-snapshot"

# folder for pipe ( we can send system_powerdown to pipe, etc )
if [ -z ${QEMU_TEMP_FOLDER} ]; then QEMU_TEMP_FOLDER="/tmp/qemupipe"; fi

#
if [ -z ${QEMU_SYSTEM} ]; then QEMU_SYSTEM=/usr/bin/qemu-system-x86_64; fi

# path to virtual machine folder
if [ -z ${QEMU_HDD_FOLDER} ]; then QEMU_HDD_FOLDER="/media/f/Data/root/qemu/"; fi

# set timeout 1m 1h
#QEMU_WATCHDOG_TIMEOUT=1m
if [ -z ${QEMU_WATCHDOG_TIMEOUT} ]; then QEMU_WATCHDOG_TIMEOUT=24h; fi

#~ configuration

#+ colors const
    colorGREEN='\033[0;32m'
    colorRED='\033[0;31m'
    colorBLUE='\033[0;34m'
    colorDef='\033[0m'
#~ colors const

#+
if [ "$imgID" = 1 ]; then
    fileName="${QEMU_HDD_FOLDER}kubuntu-16.04.5-desktop-amd64"
    vmPort=5555
    vmUser=build1604a
elif [ "$imgID" = 2 ]; then
    fileName="${QEMU_HDD_FOLDER}kubuntu-18.04.2-desktop-amd64"
    vmPort=5556
#     extFlag='-vga qxl'
    vmUser=build1804a
elif [ "$imgID" = 3 ]; then
    fileName="${QEMU_HDD_FOLDER}en_windows_10_enterprise_ltsc_2019_x64"
    vmPort=5557
    vmUser=build10a
elif [ "$imgID" = 4 ]; then
    fileName="${QEMU_HDD_FOLDER}kubuntu_20.04.2.0_desktop_amd64"
    vmPort=5558
    vmUser=build2004a
elif [ "$imgID" = 5 ]; then
    fileName="${QEMU_HDD_FOLDER}ubuntu_20.04.2.0_desktop_amd64"
    vmPort=5559
    vmUser=build2004u
else
    echo "${colorRED}***** VM id out of range [${imgID}]${colorDef}\nAbort..."
    exit 1
fi

vmName=$(basename $fileName)

clear

echo ""
echo "**************************************************************"
echo "Info:"

if [ -z ${monitorType+x} ]; # -z string is null, zero length
then

    mkdir -p $QEMU_TEMP_FOLDER

    rm -rf "${QEMU_TEMP_FOLDER}/${vmName}.in"
    mkfifo "${QEMU_TEMP_FOLDER}/${vmName}.in"

    rm -rf "${QEMU_TEMP_FOLDER}/${vmName}.out"
    mkfifo "${QEMU_TEMP_FOLDER}/${vmName}.out"

    monitorType="-monitor pipe:${QEMU_TEMP_FOLDER}/${vmName}"
    echo "**System powerdown command:"
    echo "${colorBLUE}echo system_powerdown > ${QEMU_TEMP_FOLDER}/${vmName}.in${colorDef}"
fi

echo "**ssh connect:"
echo "${colorBLUE}ssh ${vmUser}@127.0.0.1 -p ${vmPort} ${colorDef}"
echo "**Copy from host to VM:"
echo "${colorBLUE}scp -P ${vmPort} \"$HOME/Downloads/somefile.zip\" ${vmUser}@127.0.0.1:\"/home/${vmUser}/Downloads/\" ${colorDef}"
echo ""
echo "**************************************************************"

#+ watchdog # kill $mainPid
(sleep $QEMU_WATCHDOG_TIMEOUT; echo "Exit by watchdog timeout $QEMU_WATCHDOG_TIMEOUT"; echo "system_powerdown" > "${QEMU_TEMP_FOLDER}/${vmName}.in" ) &
watchdogPid=$!
#~ watchdog

#+ "trap" if this script is terminated send system_powerdown to VM
trap "echo \"Abort\"; kill $watchdog 2> /dev/null; echo \"system_powerdown\" > \"${QEMU_TEMP_FOLDER}/${vmName}.in\"" EXIT
#~  "trap" if this script is terminated send system_powerdown to VM

# runCommand=" -cpu host -smp 4 -machine accel=kvm -m 4096 -no-fd-bootchk -hda ${fileName} -boot order=cd,menu=on -device e1000,netdev=user.0 -netdev user,id=user.0,hostfwd=tcp::${vmPort}-:${vmPort} -rtc base=localtime -name ${vmName} ${extFlag} ${QEMU_SNAPSHOT_MODE} ${monitorType} -cdrom /media/f/Data/root/qemu/ubuntu-20.04.2.0-desktop-amd64.iso"

runCommand=" -cpu host -smp 4 -machine accel=kvm -m 4096 -no-fd-bootchk -hda ${fileName} -boot order=cd,menu=off -device e1000,netdev=user.0 -netdev user,id=user.0,hostfwd=tcp::${vmPort}-:${vmPort} -rtc base=localtime -name ${vmName} ${extFlag} ${QEMU_SNAPSHOT_MODE} ${monitorType}"

if [ -z "${QEMU_SNAPSHOT_MODE}" ]; # -z string is null, zero length
then
    echo "Warning! snapshot mode disabled. All changes will be saved!"
    echo "${colorRED}**** RUN $echo $(date  -Is) **** ${QEMU_SYSTEM} ${runCommand} ${colorDef}"
else
    echo "Warning! snapshot mode enabled. Changes will not be saved!"
    echo "${colorGREEN}**** RUN $echo $(date  -Is) **** ${QEMU_SYSTEM} ${runCommand} ${colorDef}"
fi

${QEMU_SYSTEM} ${runCommand} &
qemuPid=$!

#+ wait while VM exist
echo "wait for exit ${vmName} with pid=${qemuPid} ps -p ${qemuPid}"
while kill -0 ${qemuPid} 2> /dev/null; do
    sleep 1
done
#~ wait while VM exist

echo "*** exit ${vmName}"

#+ kill watchdog
kill $watchdogPid
#~ kill watchdog

#+ activate "trap"
trap - EXIT
#~ activate "trap"

#,hostfwd=tcp::5901-:5901
#nohup
