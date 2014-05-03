#/bin/bash
if [ $1 = inicio ];
then

       ## TE PIDE LA NUEVA CONTRASEÑA ##

  echo "Por favor, escribe la nueva contraseña para root:"
  read -s password1
  echo "Vuelve a escribirla, por favor:"
  read -s password2

       ## COMPROBAR QUE LAS CONTRASEÑAS NO SON DISTINTAS ##
   if [ $password1 != $password2 ]; then
        echo "Las contraseñas no coinciden"
      exit
   fi

       ## CAMBIA LA CONTRASEÑA ##
   echo -e "$password1\n$password1" | passwd root


       ## GUARDA LA CONFIGURACION INICIAL DE IPTABLES PARA RESTAURARLA AL FINALIZAR LA MIGRACION ##
   if [ -f /root/reglas_firewall_inicial ];
       then
         echo "El fichero ya existe comprueba el estado de esta migración, porque ya se ha ejecutado el script de inicio"
       exit 0
      else
	  iptables-save > /root/reglas_firewall_inicial
   fi
       ## DENIEGA AL ACCESO AL SERVIDOR DESDE FUERA SALVO PARA LAS IP's DE GIGAS Y DEJA ABIERTO EL 80 PARA PRUEBAS Y ALGUNOS BASICOS POR SI TIENE SERVICIOS EN PRODUCCION EN ESTE SERVIDOR ##
   iptables --flush
   iptables -I INPUT -s 2.139.199.247 -j ACCEPT
   iptables -I INPUT -s 2.139.199.248 -j ACCEPT
   iptables -I INPUT -s 2.139.199.249 -j ACCEPT
   iptables -I INPUT -s 2.139.220.236 -j ACCEPT
   iptables -A INPUT -p tcp --dport 8443 -j DROP
   iptables -A INPUT -p tcp --dport 2087 -j DROP
   iptables -A INPUT -p tcp --dport 2086 -j DROP
   iptables -A INPUT -p tcp --dport 2083 -j DROP
   iptables -A INPUT -p udp --dport 2082 -j DROP
   iptables -A INPUT -p tcp --dport 8880 -j DROP

   ## GUARDA LA NUEVA CONFIGURACION DEPENDIENDO DE LA DISTRIBUCION ##

   distribucion=$(cat /etc/issue )
   echo "La distribucion es "$distribucion
   echo 'Escribe 1 para RedHat/CentOS y 2 para Debian/Ubuntu'
   read version

           if [ $version = 1 ];
              then
                  iptables-save > /etc/sysconfig/iptables
              exit 0
           elif [ $version = 2 ];
              then
                  iptables-save > /etc/iptables.up.rules
                  touch /etc/network/if-up.d/iptables
                  echo "#!/bin/bash" > /etc/network/if-up.d/iptables
                  echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-up.d/iptables
                  chmod +x /etc/network/if-up.d/iptables
              else
                 echo 'No has seleccionado ni 1 ni 2'
           fi

           exit 0

else
if [ $1 = final ];
then
           ## TE PIDE LA NUEVA PASSWORD PARA ROOT  ##

                 echo "Por favor, escribe la contraseña inicial de root:"
                 read -s password1
                 echo "Vuelve a escribirla, por favor:"
                 read -s password2

           ## VERIFICA QUE NO COINCIDAN ##
                 if [ $password1 != $password2 ]; then
                 echo "Las contraseñas no coinciden"
                 exit
                 fi
                     echo -e "$password1\n$password1" | passwd root

           ## RESTAURA LA CONFIGURACION INICIAL DEL FIREWALL Y BORRA EL FICHERO QUE GUARDABA LA CONFIGURACION INICIAL##

                  iptables-restore < /root/reglas_firewall_inicial
                  rm -f /root/reglas_firewall_inicial

           ## GUARDA LA NUEVA CONFIGURACION DEPENDIENDO DE LA DISTRIBUCION ##

                  distribucion=$(cat /etc/issue )
                  echo "La distribucion es "$distribucion
                  echo 'Escribe 1 para RedHat/CentOS y 2 para Debian/Ubuntu'
                  read version

                        if [ $version = 1 ];
                    then
                          iptables-save > /etc/sysconfig/iptables
                    exit 0
                          elif [ $version = 2 ];
                    then
                          iptables-save > /etc/iptables.up.rules
                          touch /etc/network/if-up.d/iptables
                          echo "#!/bin/bash" > /etc/network/if-up.d/iptables
                          echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-up.d/iptables
                          chmod +x /etc/network/if-up.d/iptables
              else
                 echo 'No has seleccionado ni 1 ni 2'
           fi

           exit 0
                 fi
                 fi

exit