#!/bin/bash
# CSF, CMM, CMQ, CMC, CMM, CSE
# Skamasle.com
# Por Maks - Skamasle
# v 0.3.2 - Añadido rangos de ip a csf, bugs corregidos.
# 31 Enero 2014
# Use bajo su propio riesgo y responsabilidad.
firewall () {
if [ ! -d /etc/csf ]; then
	tput setaf 6
	echo "Instalando CSF - Firewall"
	cd /usr/local/src
	wget http://www.configserver.com/free/csf.tgz >/dev/null 2>&1
	tar -xzf csf.tgz > /dev/null
	cd csf 
	sh install.sh >/dev/null 2>&1
	tput bold
	echo "Listo !"
	tput sgr0
else
	echo "Parece que CSF ya esta instalado"

fi
}

cloudflareip () {
if [ -d /etc/csf ]; then
	echo "Añadiendo IPs de CloudFlare a CSF"
	csf -a 199.27.128.0/21
	csf -a 173.245.48.0/20
	csf -a 103.21.244.0/22
	csf -a 103.22.200.0/22
	csf -a 103.31.4.0/22
	csf -a 141.101.64.0/18
	csf -a 108.162.192.0/18
	csf -a 190.93.240.0/20
	csf -a 188.114.96.0/20
	csf -a 197.234.240.0/22
	csf -a 198.41.128.0/17
	csf -a 162.158.0.0/15
	csf -a 2400:cb00::/32
	csf -a 2606:4700::/32
	csf -a 2803:f800::/32
	csf -a 2405:b500::/32
	csf -a 2405:8100::/32
	tput bold
	echo "Listo rangos de IP de cloudflare añadidos al servidor !"
	tput sgr0
else 
	echo "CSF no esta instalado, instalalo antes con: sh skcs.sh csf"
fi

}

cmq () {
if [ ! -d /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmq ]; then
	tput setaf 6
	echo "Instalando CMQ - Mail Queues"
	cd /usr/local/src
	wget http://www.configserver.com/free/cmq.tgz >/dev/null 2>&1
	tar -xzf cmq.tgz >/dev/null 
	cd cmq 
	sh install.sh >/dev/null 2>&1
	tput bold
	echo "Listo !"
	tput sgr0
else
	echo "Parece que CMQ ya esta instalado"
fi
}

cmc () {
if [ ! -d /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmc ]; then
	tput setaf 6
	echo "Instalando CMC - ModSecurity Control"
	cd /usr/local/src
	wget http://www.configserver.com/free/cmc.tgz >/dev/null 2>&1
	tar -xzf cmc.tgz >/dev/null
	cd cmc 
	sh install.sh >/dev/null 2>&1
	tput bold
	echo "Listo !"
	tput sgr0
else
	echo "Parece que CMC ya esta instalado"
fi
}

cmm () {
if [ ! -d /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cmm ]; then
	tput setaf 6
	echo "Instalando CMM - Mail Manage"
	cd /usr/local/src
	wget http://www.configserver.com/free/cmm.tgz >/dev/null 2>&1
 	tar -xzf cmm.tgz >/dev/null
	cd cmm 
	sh install.sh >/dev/null 2>&1
	tput bold
	echo "Listo !"
	tput sgr0
else
	echo "Parece que CMM ya esta instalado"
fi
}

cse () {
if [ ! -d /usr/local/cpanel/whostmgr/docroot/cgi/configserver/cse ]; then
	tput setaf 6
	echo "Instalando CSE- Server Explorer"
	cd /usr/local/src
	wget http://www.configserver.com/free/cse.tgz >/dev/null 2>&1

	tar -xzf cse.tgz >/dev/null
	cd cse
	sh install.sh >/dev/null 2>&1
	tput bold
	echo "Listo !"
	tput sgr0
else
	echo "Parece que CSE ya esta instalado"
fi
}
todo () {
echo "Instalando TODO: CSE, CMM, CSF, CMQ y CMC"
firewall
cse 
cmm 
cloudflareip
cmq 
cmc
}

if [ -z "$1" ]; then
		tput bold
		tput setaf 1
	echo "###################"
	echo "Modo de ejecución:"
	echo "sh skcs.sh opcion"
	echo "###################"
		tput setaf 2
	echo "###################"
	echo "Opciones posibles (en minuscula todo):"
	echo "###################"
	echo "csf, cse, cmm, cmc, cmq, addip todo"
	echo "Ej: para instalar todo ejecuta:"
	echo "sh skcs.sh todo"
	echo "###################"
		tput setaf 6
	echo "###################"
	echo "CSF = Firewall"
	echo "CSE = Server Explorer"
	echo "CMM = Mail Manage"
	echo "CMC = ModSecurity Control"
	echo "CMQ = Mail Queues"	
	echo "ADDIP = Añade los rangos de IP de cloudflare a la lista blanca de CSF"
	echo "TODO = Instalado y hace todo lo anterior"
	echo "###################"
		tput sgr0
	exit
fi

case "$1" in
	csf)
		firewall
            ;;
         
	cse)
		cse
            ;;
         
	cmm)
		cmm
            ;;
	cmc)
		cmc
            ;;
	cmq)
		cmq
            ;;
	addip)
		cloudflareip
            ;;
	todo)	
		todo
		;;
esac
