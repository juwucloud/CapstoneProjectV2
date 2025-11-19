resource "aws_autoscaling_group" "asg" {
  default_cooldown = 30 # to avoid rapid scaling activities

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  target_group_arns   = [aws_lb_target_group.targetgroup_wordpress.arn]
  vpc_zone_identifier = [
    aws_subnet.private_subnet_az1.id,
    aws_subnet.private_subnet_az2.id
  ]

  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}
