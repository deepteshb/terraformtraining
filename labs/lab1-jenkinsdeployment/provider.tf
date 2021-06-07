terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.43.0"
    }
  }

  backend "s3" {
    bucket = "tf-backend2"
    key    = "jenkins/terraform.tfstate"
    dynamodb_table = "tf-backend"
}
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform"
}