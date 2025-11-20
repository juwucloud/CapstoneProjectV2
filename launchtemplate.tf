resource "aws_launch_template" "launch_template" {
  name          = "wordpress-template"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  depends_on = [ aws_db_instance.wordpressdb ]

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  key_name = aws_key_pair.lvl3keypair.key_name

  user_data = base64encode(<<EOF
#!/bin/bash

DB_HOST="${aws_db_instance.wordpressdb.address}"
DB_USER="${var.db_user}"
DB_PASS="${var.dbuser_password}"
DB_NAME="${var.db_name}"

# --- WAIT FOR RDS TO BE READY ---
echo "Waiting for RDS to accept connections..."

until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" 2>/dev/null; do
  echo "RDS not ready yet, retrying…"
  sleep 10
done

echo "RDS is ready!"

# --- EXPORT DB VARIABLES ---
echo "WP_DB_NAME=$DB_NAME" >> /etc/environment
echo "WP_DB_USER=$DB_USER" >> /etc/environment
echo "WP_DB_PASSWORD=$DB_PASS" >> /etc/environment
echo "WP_DB_HOST=$DB_HOST" >> /etc/environment

source /etc/environment

# Restart Apache so WordPress uses fresh config
systemctl restart httpd

EOF
  )
}