resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "tf-backend"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-tfstate"
    Environment = "production"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "dynamodb-policy"
  path        = "/"
  description = "My DynamoDB policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": aws_dynamodb_table.dynamodb-table.arn
      }
  ]
})
}

resource "aws_iam_group" "administrator"{
    name = "administrators"
}

resource "aws_iam_group_policy_attachment" "dynamodb_attach" {
  group      = aws_iam_group.administrator.name
  policy_arn = aws_iam_policy.policy.arn
}