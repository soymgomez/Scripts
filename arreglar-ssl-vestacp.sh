#!/bin/bash
#################################################
######### Script regenerar SSL VestaCP ##########
####### RaiolaNetworks raiolanetworks.es ########
#################################################

## Variables a modificar
#Email admin
$email="correo@dominio.es"

#Direcotrio VestaCP
$VESTA="/usr/local/vesta/"

##################################
############ NO TOCAR ############
##################################

# Generamos el SSL nuevo
$VESTA/bin/v-generate-ssl-cert $(hostname) $email 'ES' 'Lugo' \
     'Lugo' 'Raiola Networks' 'IT' > /tmp/vst.pem

# Genrramos los ficheros finales
crt_end=$(grep -n "END CERTIFICATE-" /tmp/vst.pem |cut -f 1 -d:)
key_start=$(grep -n "BEGIN RSA" /tmp/vst.pem |cut -f 1 -d:)
key_end=$(grep -n  "END RSA" /tmp/vst.pem |cut -f 1 -d:)

# Agregamos el SSL
cd /usr/local/vesta/ssl
sed -n "1,${crt_end}p" /tmp/vst.pem > certificate.crt
sed -n "$key_start,${key_end}p" /tmp/vst.pem > certificate.key
chown root:mail /usr/local/vesta/ssl/*
chmod 660 /usr/local/vesta/ssl/*
rm /tmp/vst.pem