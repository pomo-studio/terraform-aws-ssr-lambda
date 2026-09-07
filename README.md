# terraform-aws-ssr-lambda

A Lambda function that runs your server-rendered app, with its code loaded from S3.

**You probably want [serverless-ssr](https://registry.terraform.io/modules/pomo-studio/serverless-ssr/aws) instead.**
It creates two of these, one per region, and puts CloudFront in front of them. Come here
if you are building that arrangement yourself.

## What you get

One Lambda function, reading its deployment package from a bucket and key you nominate.
It can create an execution role for you, or use one you already have — handy when several
functions share a role.

## Using it

```hcl
module "lambda" {
  source  = "pomo-studio/ssr-lambda/aws"
  version = "~> 0.2"

  providers = { aws = aws.primary }

  function_name = "my-app-primary"
  description   = "my-app — primary region"

  s3_bucket = module.storage.lambda_deployments_primary_id
  s3_key    = "lambda/function.zip"

  handler     = "index.handler"
  runtime     = "nodejs22.x"
  memory_size = 1024
  timeout     = 30

  create_role = false
  role_arn    = aws_iam_role.lambda_execution.arn

  environment_variables = {
    NITRO_PRESET = "aws-lambda"
  }

  tags = { Project = "my-app" }
}
```

## Worth knowing

**Terraform stops watching the code after the first apply.** The function ignores changes
to its S3 bucket, key and object version, so your deploy pipeline can push new code
without Terraform putting the old package back on the next run. Infrastructure and
releases stay out of each other's way. If you would rather Terraform did track the
package, pass `source_code_hash`.

The flip side: pointing this module at a different bucket or key will not move the
function. Change it outside Terraform, or drop the lifecycle rule.

**Upload something before the first apply.** The function needs an object to exist at
that bucket and key. A placeholder zip is enough — `depends_on` it, or the first apply
fails.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether this module should create an IAM role for Lambda | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Lambda function | `string` | `""` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Environment variables for the Lambda function | `map(string)` | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler | `string` | `"index.handler"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Lambda memory size in MB | `number` | `512` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | IAM role ARN for Lambda execution (optional) | `string` | `""` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Lambda runtime | `string` | `"nodejs22.x"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | S3 bucket containing the deployment package | `string` | n/a | yes |
| <a name="input_s3_key"></a> [s3\_key](#input\_s3\_key) | S3 key for the deployment package | `string` | n/a | yes |
| <a name="input_source_code_hash"></a> [source\_code\_hash](#input\_source\_code\_hash) | Base64-encoded SHA256 hash of the deployment package | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Lambda timeout in seconds | `number` | `10` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | VPC security group IDs for the Lambda function | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | VPC subnet IDs for the Lambda function | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | ARN of the Lambda function |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the Lambda function |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Invocation ARN of the Lambda function |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
<!-- END_TF_DOCS -->
