## Scale-Out Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-cpu"
  autoscaling_group_name = aws_autoscaling_group.asg-capstone-jw1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1      # add 1 instance
  cooldown               = 180    # 3 minutes
}


## Scale-In Policy
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-cpu"
  autoscaling_group_name = aws_autoscaling_group.asg-capstone-jw1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1     # remove 1 instance
  cooldown               = 180     # 3 minutes

  policy_type = "SimpleScaling"
}

