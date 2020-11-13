provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"

  version = "1.54.0"
}

data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
 
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "archive_file" "lambda" { 
  type = "zip"
  source_file = "lambda.js"
  output_path = "lambda.zip"
}

data "aws_iam_policy_document" "cloudwatch-log-group-lambda" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
 
    resources = [
      "arn:aws:logs:::*",
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "MichaelVerhulstRoleTF"
  assume_role_policy = "${data.aws_iam_policy_document.lambda-assume-role.json}"
}

resource "aws_lambda_function" "greeter-lambda" {
  filename = "${data.archive_file.lambda.output_path}"
  function_name = "simplejsfunc"
  role = "${aws_iam_role.lambda.arn}"
  handler = "lambda.handler"
  runtime = "nodejs6.10"
  source_code_hash = "${base64sha256(file(data.archive_file.lambda.output_path))}"
}

resource "aws_iam_role_policy" "lambda-cloudwatch-log-group" {
  name = "simplefunc-logs"
  role = "${aws_iam_role.lambda.name}"
  policy = "${data.aws_iam_policy_document.cloudwatch-log-group-lambda.json}"
}
