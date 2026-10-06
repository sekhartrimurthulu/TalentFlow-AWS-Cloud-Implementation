# =========================
# EC2 IAM Role
# =========================

resource "aws_iam_role" "talentflow_ec2_role" {
  name = "talentflow-ec2-role-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# SSM Access
# =========================

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.talentflow_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# =========================
# Instance Profile
# =========================

resource "aws_iam_instance_profile" "talentflow_ec2_profile" {
  name = "talentflow-ec2-profile-terraform"
  role = aws_iam_role.talentflow_ec2_role.name

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}