
#!/bin/bash
for ip in `cat /auditoria/ips`
do
       /sbin/iptables -I INPUT -s $ip -j DROP
done
