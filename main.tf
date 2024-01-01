
resource "aws_lambda_function" "generate_random_number" {
  filename      = "lambda-function-1/lambda-function-1.zip" # Specify the path to your deployment package (ZIP file)
  function_name = "generateRandomNumber"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "handler.generateRandomNumber"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      # Add any environment variables here if needed
    }
  }
}

resource "aws_lambda_function" "check_even_odd" {
  filename      = "lambda-function-2/lambda-function-2.zip" # Specify the path to your deployment package (ZIP file)
  function_name = "checkEvenOdd"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "handler.checkEvenOdd"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      # Add any environment variables here if needed
    }
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_sfn_state_machine" "lambda_step_function" {
  name       = "LambdaStepFunction"
  role_arn   = aws_iam_role.step_function_execution_role.arn
  definition = <<EOF
{
  "Comment": "A simple AWS Step Functions state machine that invokes Lambda functions",
  "StartAt": "GenerateRandomNumber",
  "States": {
    "GenerateRandomNumber": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.generate_random_number.arn}",
      "ResultPath": "$.randomNumber",
      "Next": "CheckEvenOdd"
    },
    "CheckEvenOdd": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.check_even_odd.arn}",
      "ResultPath": "$.result",
      "End": true
    }
  }
}
EOF
}

resource "aws_iam_role" "step_function_execution_role" {
  name = "step_function_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      }
    }
  ]
}
EOF
}
resource "aws_iam_policy" "step_function_execution_policy" {
  name        = "step_function_execution_policy"
  description = "Policy to allow Step Functions to invoke Lambda functions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": [
        "${aws_lambda_function.generate_random_number.arn}",
        "${aws_lambda_function.check_even_odd.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "step_function_execution_policy_attachment" {
  policy_arn = aws_iam_policy.step_function_execution_policy.arn
  role       = aws_iam_role.step_function_execution_role.name
}