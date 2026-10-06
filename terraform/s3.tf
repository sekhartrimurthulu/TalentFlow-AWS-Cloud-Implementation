# =========================
# TalentFlow Resume S3 Bucket
# =========================

resource "aws_s3_bucket" "talentflow_resumes" {
  bucket = "sekhar-talentflow-ai-resumes-terraform-2026"

  tags = {
    Name        = "TalentFlow AI Resume Storage"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
    Purpose     = "Resume-Storage"
  }
}

# =========================
# Block Public Access
# =========================

resource "aws_s3_bucket_public_access_block" "talentflow_resumes" {
  bucket = aws_s3_bucket.talentflow_resumes.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =========================
# Versioning
# =========================

resource "aws_s3_bucket_versioning" "talentflow_resumes" {
  bucket = aws_s3_bucket.talentflow_resumes.id

  versioning_configuration {
    status = "Enabled"
  }
}

# =========================
# Server-Side Encryption
# =========================

resource "aws_s3_bucket_server_side_encryption_configuration" "talentflow_resumes" {
  bucket = aws_s3_bucket.talentflow_resumes.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}