
# 1
## Remote host

setup kvm
~~~
$ sudo apt install cpu-checker
$ kvm-ok
expected:
INFO: /dev/kvm exists
KVM acceleration can be used

$ sudo apt install qemu-kvm
or package:
$ sudo apt install qemu

$ sudo apt install libvirt-clients

List all groups on host
$ getent group|cut -d: -f1

Add user to kvm group 
$ usermod -g kvm $USER

To find group memebership for $USER
$ groups $USER

List virtual machines
ps -ef | grep qemu-system-x86_64
~~~

~~~
Server uptime & file system disk space usage
$ uptime; df -h

Check last reboot
$ last reboot
~~~
# HOST & VM
~~~
Install full language support
$ sudo apt install $(check-language-support)
~~~

# Remote host & vncserver
~~~
$ sudo apt -y install vnc4server xfce4 xfce4-goodies xfonts-75dpi xfonts-100dpi net-tools
$ vncpasswd
$ vncserver :1 -geometry 1440x900 -depth 24
$ vncserver -kill :1
$ cp ~/.vnc/xstartup ~/.vnc/xstartup.bac
$ echo 'exec /usr/bin/startxfce4 &' >> ~/.vnc/xstartup
$ vncserver :1 -geometry 1440x900 -depth 24
~~~

* Create an ssh tunnel, connect to the VNC Desktop
~~~
$ ssh <UserName>@<RemoteHostIp> -p <PortOnRemoteHost> -C -L 5901:127.0.0.1:5901
~~~


# 2
# VM config 

## update

~~~
$ sudo apt update
$ sudo apt upgrade
~~~

## install 

~~~
$ sudo apt install openssh-server
~~~

~~~
 * Muon is a graphical package manager for KDE.
$ sudo apt install muon
 * Midnight Commander is a text-mode full-screen file manager.
$ sudo apt install mc

 * VLC is the VideoLAN project's media player. 
$ sudo apt install vlc
 * Thunderbird is a full-featured email client
$ sudo apt install thunderbird
 * BitTorrent client
$ sudo apt install qbittorrent

 or
$ sudo apt install muon mc vlc thunderbird qbittorrent
~~~

## Remove unnecessary software:

### WARNING Update kubuntu before run "purge cups*" or due to bug in dependencies you completely uninstall the desktop.

~~~
$ sudo apt purge knotes*
$ sudo apt purge kmail* 
$ sudo apt purge ktorrent*
$ sudo apt purge k3b*
$ sudo apt purge korganizer*
$ sudo apt purge kontact
$ sudo apt purge amarok*
$ sudo apt purge dragonplayer*
$ sudo apt purge konversation*
$ sudo apt purge akregator
$ sudo apt purge krdc
$ sudo apt purge akonadi-server
$ sudo apt purge akonadi-backend-mysql
$ sudo apt purge kde-telepathy*
$ sudo apt purge ktnef                
$ sudo apt purge kdeconnect-plasma
$ sudo apt purge kdeconnect
$ sudo apt purge cantata
$ sudo apt purge mpd
$ sudo apt purge avahi*
$ sudo apt purge cups*
$ sudo apt purge plasma-discover
 or
$ sudo apt purge knotes* kmail* ktorrent* k3b* korganizer* kontact amarok* dragonplayer* konversation* akregator krdc akonadi-server akonadi-backend-mysql kde-telepathy* ktnef kdeconnect-plasma kdeconnect cantata mpd avahi* cups* plasma-discover
~~~

## build env

~~~
$ sudo apt-get install build-essential qt5-default qtbase5-dev qttools5-dev-tools uuid-dev devscripts pbuilder git-buildpackage git-build-recipe 
~~~

## environment:
~~~
 XDG_CURRENT_DESKTOP="KDE"
~~~

## connect to SSH SERVER

### HOST  

~~~
*generate key without passphrase
$ ssh-keygen -t rsa -b 4096 -C "keyname"
*save to ~/.ssh/keyname
~~~

~~~
*add key
$ ssh-add ~/.ssh/keyname

*Permanently add an SSH key to ~/.config/autostart-scripts/ssh-add.sh
#!/bin/sh
ssh-add $HOME/.ssh/key@name1 </dev/null
ssh-add $HOME/.ssh/key@name2 </dev/null
ssh-add $HOME/.ssh/key@name3 </dev/null
~~~

### SSH SERVER
~~~
* Enable password, disable pubkey authentication for ssh server (sshd)
/etc/ssh/sshd_config
set 'PasswordAuthentication yes'
set 'PubkeyAuthentication no'

* change sshd port '/etc/ssh/sshd_config'
set same as startup config for VM or HOST (SSH_PORT 5xxxx)

* allow ssh port
$ sudo ufw allow SSH_PORT

$ sudo systemctl restart sshd.service
~~~

~~~
* mkdir .ssh on server
$  ssh vm_login@vm_ip_port 'mkdir -p ~/.ssh'
~~~

~~~
* add public key to 'authorized_keys' on server
$ cat ~/.ssh/keyname.pub | ssh vm_login@vm_ip_port 'cat >> ~/.ssh/authorized_keys'
~~~

~~~
$ ssh vm_login@vm_ip_port
~~~

~~~
$ chmod 600 ~/.ssh/authorized_keys
~~~

~~~
Disable password, enable pubkey authentication for ssh server (sshd)
/etc/ssh/sshd_config
set 'PasswordAuthentication no'
set 'PubkeyAuthentication yes'

$ sudo systemctl restart sshd.service

$ sudo ufw status verbose
~~~

~~~
$ sudo apt install net-tools
$ sudo netstat -tulpn

* example allow port or port range
$ sudo ufw allow 5901/tcp
$ sudo ufw allow 5900:5910/tcp

$ sudo ufw status verbose
$ sudo ufw enable
~~~


### wsl (2023 upd)
~~~
Update WSL (--web-download: Use GitHub rather than the Microsoft Store.)
$ wsl --update

Show default distribution type, default distribution, and kernel version.
$ wsl --status

Show list of available Linux distributions for download.
$ wsl --list --online

Install Ubuntu 22.04 LTS as default Linux distribution on WSL. ("-d" set as default)
$ wsl --install -d Ubuntu-22.04

Lists the name of each distro, state, version. It also shows which distributions is default with an asterisk.
$ wsl --list --verbose

Immediately terminate all.
$ wsl --shutdown

Terminate the specified distribution
wsl --terminate  Ubuntu-22.04

Clean distribution
$ wsl --unregister Ubuntu-22.04

$ wsl --list

$ wsl --set-default Ubuntu-22.04

details: 
https://learn.microsoft.com/en-us/windows/wsl/basic-commands


~~~


