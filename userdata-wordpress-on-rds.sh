#!/bin/bash

# -----------------------------
# System Update & Packages
# -----------------------------
dnf update -y
dnf install -y httpd mariadb1011-server-utils php php-mysqlnd php-fpm php-json php-mbstring php-xml php-gd unzip wget

# -----------------------------
# Enable & Start Services
# -----------------------------
systemctl enable --now httpd
# systemctl enable --now mariadb => only need tools dont start it

# -----------------------------
# Download & Install WordPress
# -----------------------------
cd /tmp
wget https://wordpress.org/latest.zip
unzip latest.zip

# Move WP files
mv wordpress/* /var/www/html/

# Permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# -----------------------------
# Configure Apache default index
# -----------------------------
sed -i 's/DirectoryIndex.*/DirectoryIndex index.php index.html/' /etc/httpd/conf/httpd.conf
systemctl restart httpd

# -----------------------------
# Secure MariaDB not needed as using RDS
# -----------------------------
# MYSQL_ROOT_PASSWORD="${dbroot_password}"
# MYSQL_WP_PASSWORD="${dbuser_password}"

# mysql -u root <<EOF
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
# DELETE FROM mysql.user WHERE User='';
# DROP DATABASE IF EXISTS test;
# DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
# FLUSH PRIVILEGES;
# EOF


# -----------------------------
# Configure wp-config.php (RDS)
# -----------------------------
cd /var/www/html
cp wp-config-sample.php wp-config.php

# RD variables (must be passed via Terraform variables or SSM or secrets manager)
DB_NAME="${db_name}"
DB_USER="${db_user}"
DB_PASSWORD="${dbuser_password}"
DB_HOST="${db_endpoint}"        # e.g. mydb.xxxxxx.eu-central-1.rds.amazonaws.com

sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sed -i "s/localhost/$DB_HOST/" wp-config.php


####################### -----------------------------
# Create WP Database + User
# -----------------------------
# Wait for RDS to accept connections, retry a few times before giving up
retry_count=0
max_retries=30
until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
	retry_count=$((retry_count+1))
	echo "Waiting for RDS to be ready... attempt $retry_count/$max_retries"
	if [ "$retry_count" -ge "$max_retries" ]; then
		echo "RDS not reachable after $retry_count attempts" >&2
		break
	fi
	sleep 10
done

if mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"; then
	echo "Database $DB_NAME ensured"
else
	echo "Failed to create database $DB_NAME" >&2
fi

# -----------------------------
# Final Restart
# -----------------------------
systemctl restart httpd

