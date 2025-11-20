resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = null # gets the latest version
  identifier           = "jw-capstone-wordpressdb"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.dbuser_password
  tags = {
    Name = "jw_capstone_Wordpress_RDS_Database"
  } 



  db_subnet_group_name = aws_db_subnet_group.rds_subnets.name
  multi_az             = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}



