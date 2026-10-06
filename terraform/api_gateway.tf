# =========================
# API Gateway HTTP API
# =========================

resource "aws_apigatewayv2_api" "talentflow" {
  name          = "talentflow-api-terraform"
  protocol_type = "HTTP"
  description   = "TalentFlow AI Resume Processing API"

  tags = {
    Name        = "talentflow-api"
    Project     = var.project_name
    Environment = var.environment
    Owner       = "sekhar"
  }
}

# =========================
# Lambda Integration
# =========================

resource "aws_apigatewayv2_integration" "resume_lambda" {
  api_id = aws_apigatewayv2_api.talentflow.id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.resume_processor.invoke_arn

  payload_format_version = "2.0"
}

# =========================
# POST /resume Route
# =========================

resource "aws_apigatewayv2_route" "resume" {
  api_id = aws_apigatewayv2_api.talentflow.id

  route_key = "POST /resume"

  target = "integrations/${aws_apigatewayv2_integration.resume_lambda.id}"
}

# =========================
# Default Stage
# =========================

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.talentflow.id

  name = "$default"

  auto_deploy = true
}

# =========================
# API Gateway → Lambda Permission
# =========================

resource "aws_lambda_permission" "api_gateway" {
  statement_id = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.resume_processor.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.talentflow.execution_arn}/*/*"
}