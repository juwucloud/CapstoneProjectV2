variable "region_us_west_2" {
  type        = string
  description = "value for the region"
  default     = "us-west-2"
}

variable "aws_availability_zone_a" {
  type        = string
  description = "value for the availability zone"
  default     = "us-west-2a"
}

variable "aws_availability_zone_b" {
  type        = string
  description = "value for the availability zone"
  default     = "us-west-2b"
}

variable "aws_instance_type_t3micro" {
  type        = string
  description = "value for the instance type"
  default     = "t3.micro"
}

# getting the latest Amazon Linux 2023
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}



### only safe in personal account
# variable "wordpress_ami_id" {
#     type = string
#     description = "AMI for WordPress"
#     default = "ami-0bd84fb21f977f20a"
# }

variable "instance_type" {
    type = string
    description = "t3.micro instance"
    default = "t3.micro"
  
}




## Secrets
variable "db_user" {
    type = string
    description = "User for the WP database"
    sensitive = true
}

variable "dbuser_password" {
    type = string
    description = "The password for the user in WP database"
    sensitive = true
}

variable "db_root_user" {
    type = string
    description = "The root user for the DB"
    sensitive = true
}

variable "dbroot_password" {
    type = string
    description = "The password for the root user in DB"
    sensitive = true
}

variable "wp_admin_email" {
    type = string
    description = "The admin email for wordpress"
    sensitive = true
}

variable "db_name" {
    type = string
    description = "The name of the database"
    default = "wordpressdb"
}

