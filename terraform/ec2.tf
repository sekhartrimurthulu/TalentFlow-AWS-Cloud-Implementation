# =========================
# TalentFlow EC2
# =========================

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "talentflow_web" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_1.id

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  iam_instance_profile = aws_iam_instance_profile.talentflow_ec2_profile.name

  user_data = <<-EOF
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

  tags = {
    Name        = "talentflow-web-server"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}