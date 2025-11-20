resource "aws_autoscaling_group" "asg" {
  default_cooldown = 30 # to avoid rapid scaling activities

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  desired_capacity = 1 # 1 for testing 2 for production
  min_size         = 1 # 1 for testing 2 for production
  max_size         = 2 # 2 for testing 4 for production

  target_group_arns   = [aws_lb_target_group.targetgroup_wordpress.arn]

  vpc_zone_identifier = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]


  tag {
    key                 = "Name"
    value               = "asg"
    propagate_at_launch = true
  }
}
