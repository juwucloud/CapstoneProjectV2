resource "aws_autoscaling_group" "asg-capstone-jw1" {
  depends_on = [ aws_db_instance.wordpressdb ]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  desired_capacity = 2 # 1 for testing
  min_size         = 2 # 1 for testing
  max_size         = 4 # 2 for testing

  target_group_arns   = [aws_lb_target_group.targetgroup_wordpress.arn]

  vpc_zone_identifier = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  # Health Check Settings
  health_check_type = "ELB"
  health_check_grace_period = 720  # 12 minutes - estimated time for rds to set up

  tag {
    key                 = "Name"
    value               = "asg-capstone-jw1"
    propagate_at_launch = true
  }
}
