# =========================
# RDS Subnet Group
# =========================

resource "aws_db_subnet_group" "talentflow" {
  name        = "talentflow-db-subnet-group-terraform"
  description = "Private DB subnet group for TalentFlow AI"

  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name        = "talentflow-db-subnet-group"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# RDS MySQL
# =========================

resource "aws_db_instance" "talentflow" {
  identifier = "talentflow-rds-terraform"

  engine         = "mysql"
  engine_version = "8.4"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "talentflow"
  username = "admin"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.talentflow.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  storage_encrypted = true

  backup_retention_period = 1

  deletion_protection = false

  skip_final_snapshot = true

  tags = {
    Name        = "talentflow-rds"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}