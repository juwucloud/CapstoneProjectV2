resource "aws_launch_template" "launch_template" {
  name          = "wordpress-template"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  depends_on = [ aws_db_instance.wordpressdb ]

  vpc_security_group_ids = [
    aws_security_group.webserver_sg.id
  ]

  key_name = aws_key_pair.lvl3keypair.key_name

  user_data = base64encode (
    templatefile("${path.module}/userdata-wordpress-on-rds.sh", {
      dbroot_password = var.dbroot_password
      dbuser_password = var.dbuser_password
      db_endpoint     = aws_db_instance.wordpressdb.address
      db_name         = var.db_name
      db_user         = var.db_user
    })
  )

}