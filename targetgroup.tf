resource "aws_lb_target_group" "targetgroup_wordpress" {
  name     = "targetgroup-wordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.capstone_vpc.id

  target_type = "instance"
  deregistration_delay = 30 # waits 30 seconds before deregistering a target

  health_check {
    enabled             = true
    interval            = 30
    path                = "/var/www/html"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399" # 200 = wordpress site is up, 300s are redirects
  }

  

  tags = {
    Name = "targetgroup-wordpress"
  }
}
