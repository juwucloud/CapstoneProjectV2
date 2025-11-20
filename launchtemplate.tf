resource "aws_launch_template" "launch_template" {
  name          = "wordpress-template"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id]

  key_name = aws_key_pair.lvl3keypair.key_name


  user_data = base64encode(<<EOF
#!/bin/bash

# Write database environment variables for WordPress
echo "WP_DB_NAME=${var.db_name}" >> /etc/environment
echo "WP_DB_USER=${var.db_user}" >> /etc/environment
echo "WP_DB_PASSWORD=${var.dbuser_password}" >> /etc/environment
echo "WP_DB_HOST=${aws_db_instance.wordpressdb.address}" >> /etc/environment

# Reload them
source /etc/environment

# Restart Apache so WordPress picks up the DB values
systemctl restart httpd
EOF
  )
}
