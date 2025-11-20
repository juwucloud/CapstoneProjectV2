resource "aws_launch_template" "launch_template" {
  name          = "wordpress-template"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  key_name = aws_key_pair.lvl3keypair.key_name

  user_data = base64encode(<<EOF
#!/bin/bash

# --- Load DB variables from Terraform ---
DB_NAME="${var.db_name}"
DB_USER="${var.db_user}"
DB_PASSWORD="${var.dbuser_password}"
DB_HOST="${aws_db_instance.wordpressdb.address}"

# --- Insert them into wp-config.php ---
cd /var/www/html

# Replace placeholders (your AMI has empty fields)
sed -i "s/define('DB_NAME'.*/define('DB_NAME', '${DB_NAME}');/" wp-config.php
sed -i "s/define('DB_USER'.*/define('DB_USER', '${DB_USER}');/" wp-config.php
sed -i "s/define('DB_PASSWORD'.*/define('DB_PASSWORD', '${DB_PASSWORD}');/" wp-config.php
sed -i "s/define('DB_HOST'.*/define('DB_HOST', '${DB_HOST}');/" wp-config.php

# --- Ensure Apache picks up changes ---
systemctl restart httpd

EOF
  )
}
