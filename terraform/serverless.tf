# =========================
# SQS Queue
# =========================

resource "aws_sqs_queue" "resume_processing" {
  name                       = "talentflow-resume-processing-terraform"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = {
    Name        = "talentflow-resume-processing"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# SNS Topic
# =========================

resource "aws_sns_topic" "notifications" {
  name = "talentflow-notifications-terraform"

  tags = {
    Name        = "talentflow-notifications"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Lambda IAM Role
# =========================

resource "aws_iam_role" "lambda_role" {
  name = "talentflow-lambda-role-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
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
# Lambda Basic Execution
# =========================

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# =========================
# Lambda SQS Access
# =========================

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# =========================
# Lambda SNS Access
# =========================

resource "aws_iam_role_policy_attachment" "lambda_sns" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

# =========================
# Lambda Function
# =========================

resource "aws_lambda_function" "resume_processor" {
  function_name = "talentflow-resume-processor-terraform"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.14"
  handler = "lambda_function.lambda_handler"

  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  architectures = ["x86_64"]

  tags = {
    Name        = "talentflow-resume-processor"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}
# =========================
# SQS → Lambda Event Source
# =========================

resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.resume_processing.arn
  function_name    = aws_lambda_function.resume_processor.arn

  batch_size = 1
  enabled    = true
}
# =========================
# EventBridge → Lambda Permission
# =========================

resource "aws_lambda_permission" "eventbridge" {
  statement_id = "AllowEventBridgeInvoke"
  action       = "lambda:InvokeFunction"

  function_name = aws_lambda_function.resume_processor.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_bus.talentflow.arn
}
# =========================
# EventBridge Custom Event Bus
# =========================

resource "aws_cloudwatch_event_bus" "talentflow" {
  name = "talentflow-event-bus-terraform"

  tags = {
    Name        = "talentflow-event-bus"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# EventBridge Rule
# =========================

resource "aws_cloudwatch_event_rule" "resume_uploaded" {
  name           = "talentflow-resume-uploaded-terraform"
  description    = "Routes RESUME_UPLOADED events to TalentFlow Lambda"
  event_bus_name = aws_cloudwatch_event_bus.talentflow.name

  event_pattern = jsonencode({
    eventType = [
      "RESUME_UPLOADED"
    ]
  })
}

# =========================
# EventBridge → Lambda Target
# =========================

resource "aws_cloudwatch_event_target" "resume_lambda" {
  rule           = aws_cloudwatch_event_rule.resume_uploaded.name
  event_bus_name = aws_cloudwatch_event_bus.talentflow.name
  target_id      = "TalentFlowResumeProcessor"
  arn            = aws_lambda_function.resume_processor.arn
}