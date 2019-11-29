#!/bin/bash

cd /root
# Mise à jour de la machine
apt update -y
apt upgrade -y

# Installation des binaires les plus courants
apt --yes --force-yes install nmap
apt --yes --force-yes install zip
apt --yes --force-yes install dnsutils
apt --yes --force-yes install net-tools
apt --yes --force-yes install tzdata
apt --yes --force-yes install lynx
apt --yes --force-yes install curl
apt --yes --force-yes install git
apt --yes --force-yes install screen
apt --yes --force-yes install locate
apt --yes --force-yes install ncdu
apt --yes --force-yes install ssh

# Installation de Webmin
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.910_all.deb
dpkg -i webmin_1.910_all.deb
apt --yes --force-yes install

# Configuration du fuseau horaire
echo "tzdata tzdata/Areas select Europe" | debconf-set-selections
echo "tzdata tzdata/Zones/Europe select Paris" | debconf-set-selections
TIMEZONE="Europe/Paris"
echo $TIMEZONE > /etc/timezone


# Modification du bashrc
rm -r .bashrc
echo 'export LS_OPTIONS='--color=auto'' >> /root/.bashrc
echo 'eval "`dircolors`"' >> /root/.bashrc
echo $'alias ls=\'ls $LS_OPTIONS\'' >> /root/.bashrc
echo $'alias ll=\'ls $LS_OPTIONS -l\'' >> /root/.bashrc
echo $'alias l=\'ls $LS_OPTIONS -lA\'' >> /root/.bashrc
exec bash

# Modification de l'adresse IP et du fichier /etc/network/interfaces
rm -r /etc/network/interfaces

iface=`dmesg | grep "renamed from eth0" | cut -d : -f3 | cut -c6-`

echo '# This file describes the network interfaces available on your system' >> /etc/netwo$
echo '# and how to activate them. For more information, see interfaces(5).' >> /etc/networ$
echo '' >> /etc/network/interfaces
echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces
echo '' >> /etc/network/interfaces
echo '# The loopback network interfaces' >> /etc/network/interfaces
echo 'auto lo' >> /etc/network/interfaces
echo 'iface lo inet loopback' >> /etc/network/interfaces
echo '' >> /etc/network/interfaces
echo '# The primary network interface' >> /etc/network/interfaces
echo '' >> /etc/network/interfaces
echo "allow-hotplug $iface" >> /etc/network/interfaces
echo "iface $iface inet static" >> /etc/network/interfaces
echo "  address 192.168.10.137" >> /etc/network/interfaces
echo '  netmask 255.255.255.0' >> /etc/network/interfaces
echo "  gateway 192.168.10.254" >> /etc/network/interfaces
systemctl restart networking

# Modification du hostname
rm -r /etc/hostname
echo "CEF137" >> /etc/hostname

# Modification du resolv.conf
rm -r /etc/resolv.conf
echo 'domain tssr.ninja' >> /etc/resolv.conf
echo 'nameserver 1.1.1.1' >> /etc/resolv.conf
