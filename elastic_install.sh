#! /bin/bash
sudo -i echo "[elasticsearch]
name=Elasticsearch repository for 8.x packages
baseurl=https://artifacts.elastic.co/packages/8.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md" > /etc/yum.repos.d/elasticsearch.repo

sudo -i rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo -i sudo yum install --enablerepo=elasticsearch elasticsearch -y

sudo systemctl start elasticsearch.service

sudo systemctl enable elasticsearch.service

sudo echo "Elastic Search Installed"
