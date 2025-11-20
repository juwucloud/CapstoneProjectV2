# Public Route Table

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.capstone_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WPig.id
  }

  tags = {
    Name = "publicRT"
  }
  
}

# Private Route Table

#####!!! For Project without NAT Gateway. In Production a NAT Gateway should be used for outbound traffic (e.g. updates) !!!#####

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.capstone_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "privateRT"
  }
  
}


# Associate Public Routetables
resource "aws_route_table_association" "publica" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "publicb" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.publicRT.id
}

# Associate Private Routetables 
resource "aws_route_table_association" "privatea" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.privateRT.id
}

resource "aws_route_table_association" "privateb" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.privateRT.id
}