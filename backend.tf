terraform {
  backend "s3" {
    bucket         = "nti-final-tfstate-842303506852-eu-west-1"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "nti-finalproject-terraform-lock"
    encrypt        = true
  }
}
