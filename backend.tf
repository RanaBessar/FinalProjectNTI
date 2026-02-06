terraform {
  backend "s3" {
    bucket         = "nti-finalproject-terraform-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nti-finalproject-terraform-lock"
    encrypt        = true
  }
}
