#!/bin/bash

for ip in `cat /auditoria2/ips`
do
        url=http://www.stopforumspam.com/api?ip=$ip
        respuesta=`curl -s $url | sed -ne '/<\/appears>/ { s/<[^>]*>\(.*\)<\/appears>/\1/; p }'`
        #aparece=`awk -vRS="</appears>" '{gsub(/.*<appears.*>/,"");print}' '$respuesta'`
        if [ $respuesta = "yes" ];
        then
                echo $ip
#       else
#               echo $ip "  No aparece"
        fi

done
