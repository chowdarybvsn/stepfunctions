terraform {
  backend "s3" {
    bucket         = "terraform-project-1-2023"
    key            = "StepF/backend.tfstate"
    region         = "us-east-1"
    dynamodb_table = "StepF"
  }
}
