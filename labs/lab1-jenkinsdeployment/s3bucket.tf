resource "aws_s3_bucket" "tfbackend2" {
  bucket = "tf-backend2"

  versioning {
    enabled = true
  }

  tags = merge(var.default_tags, {
    Name        = "tf-backend"
    Environment = "Training"
  })
}

resource "aws_iam_policy" "s3-bucket-policy"{
   
   name        = "tf-state-policy"
  path        = "/"
  description = "Backend Policy for TFStateManagement"

   policy = jsonencode({"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::tf-backend2"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::tf-backend2/*"
    }
  ]
})
}