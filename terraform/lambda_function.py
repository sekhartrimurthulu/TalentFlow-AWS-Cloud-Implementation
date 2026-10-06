import json
import boto3

sns = boto3.client("sns")

SNS_TOPIC_ARN = "REPLACE_WITH_TERRAFORM_SNS_ARN"


def lambda_handler(event, context):

    print("TalentFlow AI Resume Processor started")
    print("Received event:")
    print(json.dumps(event))

    message = {
        "eventType": "RESUME_PROCESSED",
        "status": "SUCCESS",
        "message": "Resume processing completed successfully"
    }

    if SNS_TOPIC_ARN.startswith("REPLACE"):
        print("SNS topic ARN will be configured by Terraform.")

    return {
        "statusCode": 200,
        "body": json.dumps(message)
    }