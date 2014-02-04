#!/bin/bash
# Interactive PoPToP install script for an OpenVZ VPS
# Tested on Debian 5, 6, and Ubuntu 11.04
# April 2, 2013 v1.11
# Author: Commander Waffles
# http://www.putdispenserhere.com/pptp-debian-ubuntu-openvz-setup-script/

echo “######################################################”
echo “Interactive PoPToP Install Script for an OpenVZ VPS”
echo
echo “Make sure to contact your provider and have them enable”
echo “IPtables and ppp modules prior to setting up PoPToP.”
echo “PPP can also be enabled from SolusVM.”
echo
echo “You need to set up the server before creating more users.”
echo “A separate user is required per connection or machine.”
echo “######################################################”
echo
echo
echo “######################################################”
echo “Select on option:”
echo “1) Set up new PoPToP server AND create one user”
echo “2) Create additional users”
echo “######################################################”
read x
if test $x -eq 1; then
echo “Enter username that you want to create (eg. client1 or john):”
read u
echo “Specify password that you want the server to use:”
read p

# get the VPS IP
ip=`ifconfig venet0:0 | grep ‘inet addr’ | awk {‘print $2′} | sed s/.*://`

echo
echo “######################################################”
echo “Downloading and Installing PoPToP”
echo “######################################################”
apt-get update
apt-get -y install pptpd

echo
echo “######################################################”
echo “Creating Server Config”
echo “######################################################”
cat > /etc/ppp/pptpd-options < /etc/pptpd.conf
echo “logwtmp” >> /etc/pptpd.conf
echo “localip $ip” >> /etc/pptpd.conf
echo “remoteip 10.1.0.1-100″ >> /etc/pptpd.conf

# adding new user
echo “$u    *   $p  *” >> /etc/ppp/chap-secrets

echo
echo “######################################################”
echo “Forwarding IPv4 and Enabling it on boot”
echo “######################################################”
cat >> /etc/sysctl.conf < /etc/iptables.conf

cat > /etc/network/if-pre-up.d/iptables <> /etc/ppp/ip-up <> /etc/ppp/chap-secrets

echo
echo “######################################################”
echo “Addtional user added!”
echo “Connect to your VPS at $ip with these credentials:”
echo “Username:$u ##### Password: $p”
echo “######################################################”

else
echo “Invalid selection, quitting.”
exit
fi