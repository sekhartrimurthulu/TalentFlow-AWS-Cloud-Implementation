# =========================
# ALB Security Group
# =========================

resource "aws_security_group" "alb" {
  name        = "talentflow-alb-sg"
  description = "Security group for TalentFlow Application Load Balancer"
  vpc_id      = aws_vpc.talentflow.id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "talentflow-alb-sg"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# EC2 Security Group
# =========================

resource "aws_security_group" "ec2" {
  name        = "talentflow-ec2-sg"
  description = "Security group for TalentFlow EC2 application servers"
  vpc_id      = aws_vpc.talentflow.id

  ingress {
    description     = "Allow HTTP only from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "talentflow-ec2-sg"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# RDS Security Group
# =========================

resource "aws_security_group" "rds" {
  name        = "talentflow-rds-sg"
  description = "Security group for TalentFlow RDS database"
  vpc_id      = aws_vpc.talentflow.id

  ingress {
    description     = "Allow MySQL only from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "talentflow-rds-sg"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}