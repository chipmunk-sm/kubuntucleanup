
# 1
## HOST

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

# 2
# VM config 

## update

~~~
$ sudo apt update
$ sudo apt upgrade
 * Run the "purge cups*" will damage the system without the latest updates.
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
$ sudo apt-get install build-essential qt5-default qtbase5-dev qttools5-dev-tools uuid-dev devscripts pbuilder git-buildpackage 
~~~

## environment:
~~~
 XDG_CURRENT_DESKTOP="KDE"
~~~

## SSH to VM from HOST 

### host

~~~
*generate key without passphrase
$ ssh-keygen -t rsa -b 4096 -C "keyname"
~~~

~~~
*add key
$ ssh-add ~/.ssh/keyname
~~~

~~~
* mkdir .ssh on VM
$  ssh vm_login@vm_ip_port 'mkdir -p ~/.ssh'
~~~

~~~
* copy key to VM
$ cat ~/.ssh/keyname.pub | ssh vm_login@vm_ip_port 'cat >> ~/.ssh/authorized_keys'
~~~

~~~
$ ssh vm_login@vm_ip_port
~~~

### VM

~~~
chmod 600 ~/.ssh/authorized_keys
~~~

