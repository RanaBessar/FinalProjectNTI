terraform {
  backend "s3" {
    bucket         = "nti-final-tfstate-842303506852-us-east-1-2026"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "nti-finalproject-terraform-lock"
    encrypt        = true
  }
}
