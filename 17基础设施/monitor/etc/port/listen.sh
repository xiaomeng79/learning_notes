#!/bin/bash
ListeningPort=`netstat -an | grep ":10010" | awk '$NF == "LISTEN" {print $0}' | wc -l`
if [ $ListeningPort -eq 0 ]
then
{
  echo "`date` : listener port is down">>/usr/local/listen_port_10010.log
  systemctl restart ip_tunnel_proxy
}
else
{
 echo "`date` : 10010端口正常" >>/usr/local/listen_port_10010.log
}
fi