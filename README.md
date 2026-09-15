# terraform-aws-ssr-lambda

[![Terraform Validation](https://github.com/pomo-studio/terraform-aws-ssr-lambda/actions/workflows/terraform.yml/badge.svg)](https://github.com/pomo-studio/terraform-aws-ssr-lambda/actions/workflows/terraform.yml)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-844FBA?logo=terraform)](https://registry.terraform.io/modules/pomo-studio/ssr-lambda/aws)

[Changelog](CHANGELOG.md)

A Lambda function that runs your server-rendered app, with its code loaded from S3.

## When to use it

Deploy a Lambda function whose code lives in S3, with an execution role you either create here or supply. Reach for it whenever a function should be released by uploading a package rather than rebuilding Terraform: a server-rendered app, an API handler, or a background worker.

It is also the compute piece of the [Serverless SSR blueprint](https://registry.terraform.io/modules/pomo-studio/serverless-ssr/aws), which creates two of these, one per region, behind CloudFront, with a reference application at [ssr.pomo.dev](https://ssr.pomo.dev).

## Quickstart

```hcl
module "lambda" {
  source  = "pomo-studio/ssr-lambda/aws"
  version = "~> 0.2"

  providers = { aws = aws.primary }

  function_name = "my-app-primary"
  description   = "my-app primary region"

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

## What it creates

- One `aws_lambda_function`, reading its package from the bucket and key you nominate.
- An execution role, when `create_role` is true.
- The basic execution policy attachment for that role.

## Design decisions

- **Terraform stops watching the code after the first apply.** The function ignores changes to its S3 bucket, key, and object version, so your deploy pipeline can push new code without Terraform restoring the old package. If you would rather Terraform tracked the package, pass `source_code_hash`.
- **Upload before you apply.** The function needs an object to exist at that bucket and key. A placeholder zip is enough; `depends_on` it, or the first apply fails.
- **Role optional.** Supply an existing `role_arn` to share one execution role across functions, or let the module create one.

## Examples

- [Basic](examples/basic/)

## Reference

<details>
<summary>Reference</summary>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.64.0 |

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

</details>

## Support and license

Part of [postmodern.tf](https://pomo.dev), the open-source AWS infrastructure
collection created by [André Pitanga](https://pomo.studio). Regenerate the reference with `terraform-docs` v0.20.0 (`terraform-docs .`); CI fails on drift.

See the [contribution guide](https://github.com/pomo-studio/.github/blob/main/CONTRIBUTING.md) and [security policy](https://github.com/pomo-studio/.github/blob/main/SECURITY.md).

MIT licensed. See [LICENSE](LICENSE).
