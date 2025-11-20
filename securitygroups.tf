#####################################################################
# SSH - Security Group
resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "Allows SSH access to Bastion Host instances within the VPC."
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description = "Allows inbound SSH traffic from any IPv4 address."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to trusted IPs only.
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
  
  ingress {
    description     = "Inbound SSH from Bastion Host security group."
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh_sg.id]
  }

### Egress Rules are left out because of missing NAT Gateway in this project.
  # egress {
  #   description = "Allow all outbound traffic for updates, RDS access, etc."
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

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
    security_groups          = [aws_security_group.webserver_sg.id]
  }

  ingress { # only for Project demonstration purposes. In production, this should be removed.
    description              = "Allows inbound MySQL traffic from the bastion (ssh) security group."
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.ssh_sg.id]
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

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allows public HTTP/HTTPS traffic to the Application Load Balancer."
  vpc_id      = aws_vpc.capstone_vpc.id

  ingress {
    description = "Allows inbound HTTP from anywhere."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  # Optional HTTPS, certificate is required
  # ingress {
  #   description = "Allows inbound HTTPS from anywhere."
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ALB does not need outbound traffic for Internet access, only to forward traffic to webservers

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}

