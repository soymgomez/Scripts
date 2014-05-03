if [ $1 = install ];
then
read -r -p "Asegúrate de que el servicio proxy inverso nginx está detenido en el Plesk. ¿Continuar? (s/n) " respuesta
if [[ $respuesta =~ ^[Ss]$ ]]
then
apt-get install -y varnish
sed -i s/:6081/:80/ /etc/default/varnish
sed -i s/'Listen 80'/'Listen 7082'/ /etc/apache2/ports.conf
cp -a /usr/local/psa/admin/conf/templates/default /usr/local/psa/admin/conf/templates/custom
find /usr/local/psa/admin/conf/templates/custom -type f | xargs sed -r -i~ 's/\{?\$VAR->server->webserver->httpPort\}?/7082/g'
ip=$(ifconfig eth0| awk -F':' '/inet addr/&&!/127.0.0.1/{split($2,_," ");print _[1]}')
sed -i s/8080/7082/ /etc/varnish/default.vcl
sed -i "s/127.0.0.1/$ip/g" /etc/varnish/default.vcl
/usr/local/psa/admin/bin/httpdmng --reconfigure-all
/etc/init.d/apache2 restart
/etc/init.d/varnish restart
fi
else
if [ $1 = remove ];
then
sed -i s/'Listen 7082'/'Listen 80'/ /etc/apache2/ports.conf
/etc/init.d/varnish stop
rm -rf /usr/local/psa/admin/conf/templates/custom
apt-get remove -y varnish
/usr/local/psa/admin/bin/httpdmng --reconfigure-all
/etc/init.d/apache2 restart
fi
fi