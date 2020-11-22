provider "aws" {
  region                      = "eu-west-2"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_force_path_style         = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"

  endpoints {
    sns              = "http://localhost:4566"
    sqs              = "http://localhost:4566"
    dynamodb         = "http://localhost:4566"
    s3               = "http://localhost:4572"
    cloudwatch       = "http://localhost:4566"
    ssm              = "http://localhost:4566"
    cloudwatchevents = "http://localhost:4566"
  }
}

module "wip" {
  source = "../"
  event_bus = aws_sns_topic.event_bus
}

resource "aws_s3_bucket" "lambdas" {
  bucket = "lambdas-deployments"
  acl = "private"
  tags = {
    Name = "Lambdas deployment bucket"
  }
}

resource "aws_sns_topic" "event_bus" {
  name = "EventBus"
}