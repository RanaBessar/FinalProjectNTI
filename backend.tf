terraform {
  backend "s3" {
    bucket         = "nti-finalproject-terraform-state-rana2"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nti-finalproject-terraform-lock-rana2"
    encrypt        = true
  }
}
