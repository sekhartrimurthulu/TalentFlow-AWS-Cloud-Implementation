# TalentFlow AI – Deployment Documentation

## 1. Project Overview

TalentFlow AI is an AWS Cloud implementation of a recruitment platform. The project uses Terraform to provision and manage AWS infrastructure and includes serverless, compute, storage, database, security, monitoring, and event-driven services.

## 2. AWS Region

The project is deployed in:

- AWS Region: `ap-south-1` (Mumbai)
- Environment: `dev`

## 3. Infrastructure Deployment

The infrastructure is managed using Terraform.

Main Terraform components include:

- VPC and networking
- Public and private subnets
- Security Groups
- IAM roles and permissions
- EC2
- Application Load Balancer
- Auto Scaling
- S3
- RDS
- Lambda
- API Gateway
- CloudWatch
- Serverless and event-driven components

## 4. Terraform Deployment Process

The deployment process follows these steps:

### Step 1 – Initialize Terraform

```bash
terraform init
