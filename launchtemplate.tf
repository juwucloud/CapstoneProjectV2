resource "aws_launch_template" "launch_template" {
  depends_on = [ aws_db_instance.wordpressdb ]
  name          = "wordpress-template"
  image_id      = var.wordpress_ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  key_name = aws_key_pair.lvl3keypair.key_name

  user_data = base64encode(<<EOF
#!/bin/bash


DB_HOST="${aws_db_instance.wordpressdb.address}"
DB_USER="${var.db_user}"
DB_PASS="${var.dbuser_password}"

# Wait for MySQL to accept connections
echo "Waiting for RDS to be ready..."

until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" 2>/dev/null; do
  echo "RDS not ready yet..."
  sleep 10
done

echo "RDS is ready!"

# --- Write DB variables into environment ---
echo "WP_DB_NAME=${var.db_name}" >> /etc/environment
echo "WP_DB_USER=${var.db_user}" >> /etc/environment
echo "WP_DB_PASSWORD=${var.dbuser_password}" >> /etc/environment
echo "WP_DB_HOST=${aws_db_instance.wordpressdb.address}" >> /etc/environment

# Load them for this session
source /etc/environment

# --- Ensure Apache reloads env vars ---
systemctl restart httpd

EOF
  )
}
