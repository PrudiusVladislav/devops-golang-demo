#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx

yum install -y golang
git clone https://github.com/PrudiusVladislav/devops-golang-demo /opt/silly-demo
cd /opt/silly-demo
go build
./silly-demo &
cat <<EOT > /etc/nginx/conf.d/silly-demo.conf
server {
    listen 80;
    location / {
        proxy_pass http://localhost:8080;
    }
}
EOT
systemctl restart nginx