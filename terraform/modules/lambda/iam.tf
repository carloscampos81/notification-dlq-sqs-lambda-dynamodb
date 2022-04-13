locals {
  function_role_name = "${var.function_name}-${var.environment}"
}
resource "aws_iam_role" "lambda_function_role" {
  name               = local.function_role_name
  assume_role_policy = "${data.aws_iam_policy_document.lambda_trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role       = "${aws_iam_role.lambda_function_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "dynamodb_read_write_policy" {
    name    = "lambda_dynamodb_read_write_policy"
    role    = aws_iam_role.lambda_function_role.id
    policy  = jsonencode({
        "Version": "2012-10-17",
        "Statement": [{
			"Effect": "Allow",
			"Action": [
				"dynamodb:BatchGetItem",
				"dynamodb:GetItem",
				"dynamodb:Query",
				"dynamodb:Scan",
				"dynamodb:BatchWriteItem",
				"dynamodb:PutItem",
				"dynamodb:UpdateItem",
        "dynamodb:DescribeStream",
        "dynamodb:GetRecords",
        "dynamodb:GetShardIterator",
        "dynamodb:ListStreams"
			],
        "Resource": "arn:aws:dynamodb:*:*:table/*"
        },
        {
            "Sid": "GetStreamRecords",
            "Effect": "Allow",
            "Action": "dynamodb:GetRecords",
            "Resource": "arn:aws:dynamodb:*:*:table/*/stream/* "
        },
        {
        "Sid": "WriteLogStreamsAndGroups",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
        },
        {
        "Sid": "CreateLogGroup",
        "Effect": "Allow",
        "Action": "logs:CreateLogGroup",
        "Resource": "*"
        }
        ]     
    })
}

resource "aws_iam_role_policy" "sqs_policy" {
    name    = "lambda_sqs_policy"
    role    = aws_iam_role.lambda_function_role.id
    policy  = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
              "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
      ]
    })
}