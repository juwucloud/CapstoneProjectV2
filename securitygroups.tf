#####################################################################
# SSH - Security Group
resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allows SSH access to EC2 instances within the VPC."
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description = "Allows inbound SSH traffic from any IPv4 address."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allows all outbound traffic to any IPv4 address."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_sg"
  }
}

#####################################################################

# Webserver Security Group
# Accepts http traffic only from the ALB-security-group
resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allows inbound HTTP traffic from the ALB only."
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description     = "Inbound HTTP from the ALB security group."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic for updates, RDS access, etc."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver_sg"
  }
}


#####################################################################


# MYSQL - Security Group
resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allows MySQL access only from the webserver security group."
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description              = "Allows inbound MySQL traffic from the webserver security group."
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.http_sg.id]
  }

  egress {
    description = "Allows all outbound traffic to any IPv4 address."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql_sg"
  }
}


#####################################################################

# Application Load Balancer - Security Group
resource "aws_security_group" "alb_sg" {
  name        = "ALB Security Group"
  vpc_id      = aws_vpc.capstone_vpc.id
  description = "Allow HTTP access to Application Load Balancer"
  tags = {
    name = "alb_security_group"
  }
}

# Webserver - Security Group access only from ALB
resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Security Group for private ASG instances"
  vpc_id      = aws_vpc.capstone_vpc.id

  # Allow only ALB to reach webservers
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-sg"
  }
}
