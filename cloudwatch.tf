## CloudWatch Alarm for Scale-Out
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  period              = 60
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = 50

  alarm_description   = "Scale out if CPU > 50% for 3 minutes"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn
  ]
}

## CloudWatch Alarm for Scale-In
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  period              = 60
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  threshold           = 20

  alarm_description   = "Scale in if CPU < 20% for 3 minutes"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]
}

