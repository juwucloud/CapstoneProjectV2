resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet_1.id
    
    tags = {
        Name = "capstone_nat_gateway"
    }
    depends_on = [ aws_internet_gateway.WPig ]
    }
