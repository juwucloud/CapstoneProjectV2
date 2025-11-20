resource "aws_instance" "bastionhost" {
  ami                    = var.bastionhost_ami    #latest ami linux 2023
  instance_type          = var.aws_instance_type_t3micro
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  user_data              = file("${path.module}/bastionuserdata.sh")
  key_name               = aws_key_pair.lvl3keypair.key_name

  tags = {
    Name = "bastionhost"
  }
}
