# Basic Lambda Example

Shows the module creating an SSR Lambda function from an S3 object, with a new execution role.

## What it creates

- One `aws_lambda_function` named `example-lambda`, loaded from `example-bucket` at `lambda/function.zip`.
- One `aws_iam_role` named `example-lambda-role` because `create_role = true`.
- One `aws_iam_role_policy_attachment` for the AWS basic execution role.
- Handler, runtime, memory, and timeout fall back to the module defaults.

## Before you start

- AWS provider, region `us-east-1`.
- The example sets mock credentials and skip flags. It is meant for `init` and `plan` offline.
- Replace the mock credentials with real ones before `apply`. The bucket and object must exist first.

## Run it

```bash
terraform init
terraform plan
terraform apply
```

## Clean up

```bash
terraform destroy
```
