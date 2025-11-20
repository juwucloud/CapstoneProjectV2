
# Output VPC ID
output "vpc_id" {
  value = aws_vpc.capstone_vpc.id
}

# Output Bastion Host Public IP
output "bastion_public_ip" {
  value = aws_instance.bastion-host.public_ip
}

# Output ALB DNS Name
output "alb_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}

# Output RDS Endpoint
output "rds_endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

