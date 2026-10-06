data "aws_availability_zones" "available" {
  state = "available"
}

# =========================
# TalentFlow VPC
# =========================

resource "aws_vpc" "talentflow" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "talentflow-vpc"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Internet Gateway
# =========================

resource "aws_internet_gateway" "talentflow_igw" {
  vpc_id = aws_vpc.talentflow.id

  tags = {
    Name        = "talentflow-igw"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Public Subnet 1
# =========================

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.talentflow.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "sekhar_talentflow_public_subnet"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
    Tier        = "Public"
  }
}

# =========================
# Private Subnet 1
# =========================

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.talentflow.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "ap-south-1b"

  tags = {
    Name        = "sekhar_talentflow_private_subnet"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
    Tier        = "Private"
  }
}

# =========================
# Private Subnet 2
# =========================

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.talentflow.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "ap-south-1c"

  tags = {
    Name        = "sekhar_talentflow_private_subnet_2"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
    Tier        = "Private"
  }
}

# =========================
# Public Subnet 2
# =========================

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.talentflow.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "sekhar_talentflow_public_subnet_2"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
    Tier        = "Public"
  }
}

# =========================
# Elastic IP for NAT Gateway
# =========================

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "talentflow-nat-eip"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# NAT Gateway
# =========================

resource "aws_nat_gateway" "talentflow_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.talentflow_igw
  ]

  tags = {
    Name        = "talentflow-nat"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Public Route Table
# =========================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.talentflow.id

  tags = {
    Name        = "talentflow-public-rt"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.talentflow_igw.id
}
# =========================
# Public Subnet Associations
# =========================

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}
# =========================
# Private Route Table
# =========================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.talentflow.id

  tags = {
    Name        = "talentflow-private-rt"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.talentflow_nat.id
}
# =========================
# Private Subnet Associations
# =========================

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}