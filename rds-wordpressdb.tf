resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 20
  # max_allocated_storage = 100 # uncomment to enable storage autoscaling. prevents storage full issues
  backup_retention_period = 0 # backups disabled intentionally for sandbox environment. for production set to at least 7
  engine               = "mysql"
  engine_version       = null # gets the latest version
  identifier           = "jw-capstone-wordpressdb"
  instance_class       = "db.t3.micro"
  storage_type         = "gp2"
  username             = var.db_user
  password             = var.dbuser_password
  # delete_protection    = true # uncomment to prevent deletion of RDS instance. Useful for production!
  tags = {
    Name = "jw_capstone_Wordpress_RDS_Database"
  } 



  db_subnet_group_name = aws_db_subnet_group.rds_subnets.name
  multi_az             = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
}