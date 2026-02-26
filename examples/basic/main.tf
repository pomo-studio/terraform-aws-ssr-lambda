provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
}

module "lambda" {
  source = "../.."

  function_name = "example-lambda"
  create_role   = true
  s3_bucket     = "example-bucket"
  s3_key        = "lambda/function.zip"
}
