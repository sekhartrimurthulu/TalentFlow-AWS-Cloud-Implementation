# TalentFlow AI – AWS Cloud Implementation

## Project Overview

TalentFlow AI is an AI-powered recruitment and talent management application supported by a secure, scalable, and highly available AWS cloud architecture.

This project focuses on implementing the AWS infrastructure around the existing TalentFlow AI application using AWS services and Infrastructure as Code with Terraform.

## Objectives

The main objectives of this project are:

- Build a secure AWS cloud infrastructure
- Deploy compute resources using Amazon EC2
- Configure networking using Amazon VPC
- Implement high availability using Application Load Balancer and Auto Scaling
- Use Amazon RDS for database services
- Use Amazon S3 for cloud storage
- Implement serverless processing using AWS Lambda
- Configure API Gateway for application APIs
- Implement event-driven processing using SQS and EventBridge
- Configure SNS notifications
- Monitor resources using Amazon CloudWatch
- Apply IAM and network security best practices
- Manage infrastructure using Terraform
- Apply AWS cost optimization practices

## AWS Services Used

| Category | AWS Services |
|---|---|
| Networking | Amazon VPC, Subnets, Route Tables, Internet Gateway |
| Compute | Amazon EC2 |
| Load Balancing | Application Load Balancer |
| Scaling | Auto Scaling |
| Database | Amazon RDS |
| Storage | Amazon S3 |
| Serverless | AWS Lambda, API Gateway |
| Messaging | Amazon SQS, Amazon SNS |
| Event Processing | Amazon EventBridge |
| Monitoring | Amazon CloudWatch |
| Security | AWS IAM, Security Groups |
| Infrastructure as Code | Terraform |
| Content Delivery | Amazon CloudFront |
| DNS | Amazon Route 53 |
| Cost Management | AWS Cost Explorer, AWS Budgets |

## Architecture

The project uses a multi-service AWS architecture to provide compute, database, storage, serverless processing, event-driven communication, monitoring, and security.

The architecture diagram is available in:

`architecture/architecture diagram-talentflow AI.png`

## Application Testing

The TalentFlow AI application was accessed through the AWS cloud environment and the application dashboard was successfully reached.

The resume processing API was also tested through API Gateway.

Successful API response:

```json
{
  "eventType": "RESUME_PROCESSED",
  "status": "SUCCESS",
  "message": "Resume processing completed successfully"
}
