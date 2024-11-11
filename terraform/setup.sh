#!/bin/bash
dnf update -y
dnf install -y nginx postgresql
systemctl start nginx
systemctl enable nginx

dnf install -y golang
git clone https://github.com/PrudiusVladislav/devops-golang-demo /opt/silly-demo
cd /opt/silly-demo
go build

echo "installed nginx, postgresql, golang and cloned the silly-demo"

export DB_ENDPOINT=${db_endpoint}
export DB_PORT=5432
export DB_USER=mydbuser
export DB_PASS=password
export DB_NAME=mydb

echo "populating db: $DB_ENDPOINT, $DB_PORT, $DB_USER, $DB_PASS, $DB_NAME"
psql -h $DB_ENDPOINT -U $DB_USER -W $DB_PASS -f /opt/silly-demo/db_schema.sql

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