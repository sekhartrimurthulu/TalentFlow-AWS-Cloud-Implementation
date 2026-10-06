# =========================
# Launch Template
# =========================

resource "aws_launch_template" "talentflow" {
  name = "talentflow-launch-template-terraform"

  image_id = data.aws_ssm_parameter.amazon_linux_2023.value

  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.talentflow_ec2_profile.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx

              cat > /usr/share/nginx/html/index.html <<'HTML'
              <html>
              <head>
                <title>TalentFlow AI</title>
              </head>
              <body>
                <h1>TalentFlow AI</h1>
                <h2>AWS Cloud Application Server</h2>
                <p>Application server is running successfully.</p>
                <p>Environment: Dev</p>
              </body>
              </html>
              HTML
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "talentflow-asg-server"
      Project     = var.project_name
      Environment = var.environment
      Owner       = "sekhar"
    }
  }
}

# =========================
# Auto Scaling Group
# =========================

resource "aws_autoscaling_group" "talentflow" {
  name = "talentflow-asg-terraform"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  target_group_arns = [
    aws_lb_target_group.talentflow.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.talentflow.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "talentflow-asg-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "sekhar"
    propagate_at_launch = true
  }
}

# =========================
# CPU Target Tracking
# =========================

resource "aws_autoscaling_policy" "cpu" {
  name                   = "talentflow-cpu-target-tracking"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.talentflow.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}