#!/bin/bash

mkdir -p /opt/node_exporter
install_name=node_exporter-1.3.1.linux-amd64
wget -c https://github.com/prometheus/node_exporter/releases/download/v1.3.1/${install_name}.tar.gz

tar -zxvf ${install_name}.tar.gz

sudo cp ${install_name}/node_exporter /opt/node_exporter/
sudo chmod +x /opt/node_exporter/node_exporter

sudo cp node_exporter.service /usr/lib/systemd/system/

sudo systemctl daemon-reload 
sudo systemctl enable node_exporter.service 
sudo systemctl start node_exporter.service 

# 查看日志
#journalctl -f -u node_exporter.service

