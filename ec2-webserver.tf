

# EC2 Webserver Instance in us-west-2a
resource "aws_instance" "WebserverInstance" {
    # giving the latest ami to the ec2 instance if no ami is configured
    ami = var.webserver_ami != null ? var.webserver_ami : data.aws_ssm_parameter.al2023_latest.value
    instance_type           = var.instance_type
    availability_zone       = var.aws_availability_zone_a
    vpc_security_group_ids  = [
        aws_security_group.ssh_sg.id, 
        aws_security_group.http_sg.id
    ]
    key_name                = aws_key_pair.wp_key.key_name
    subnet_id               = aws_subnet.public_subnet_1.id

    # worpress + mariadb + php
    user_data = templatefile("${path.module}/userdata-wordpress-on-rds.sh", {
    dbroot_password = var.dbroot_password
    dbuser_password = var.dbuser_password
    db_password     = var.dbuser_password
    db_endpoint     = aws_db_instance.wordpressdb.address
    db_name         = var.db_name
    db_user         = var.db_user

  })

    tags = {
        Name = "Wordpress_Webserver"
    }
  
}