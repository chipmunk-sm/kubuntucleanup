# VM config 

## install 

~~~
sudo apt install muon
sudo apt install gparted
sudo apt install vlc
sudo apt install thunderbird
sudo apt install qbittorrent
~~~

~~~
sudo apt install muon gparted vlc thunderbird qbittorrent
~~~

## Remove trash:

~~~
sudo apt purge knotes*
sudo apt purge kmail* 
sudo apt purge ktorrent*
sudo apt purge k3b*
sudo apt purge korganizer*
sudo apt purge kontact
sudo apt purge amarok*
sudo apt purge dragonplayer*
sudo apt purge konversation*
sudo apt purge akregator
sudo apt purge krdc
sudo apt purge akonadi-server
sudo apt purge akonadi-backend-mysql
sudo apt purge kde-telepathy*
sudo apt purge ktnef                
sudo apt purge kdeconnect-plasma
sudo apt purge kdeconnect
sudo apt purge cantata
sudo apt purge mpd
~~~

~~~
sudo apt purge knotes* kmail* ktorrent* k3b* korganizer* kontact amarok* dragonplayer* konversation* akregator krdc akonadi-server akonadi-backend-mysql kde-telepathy* ktnef kdeconnect-plasma kdeconnect cantata mpd
~~~

~~~
*can damage system
sudo apt purge cups*
sudo apt purge avahi*
~~~

~~~
*can damage system
sudo apt purge cups* avahi*
~~~

## environment:

~~~
 XDG_CURRENT_DESKTOP="KDE"
~~~

## build env

~~~
sudo apt-get install build-essential qt5-default qtbase5-dev qttools5-dev-tools uuid-dev devscripts
~~~
