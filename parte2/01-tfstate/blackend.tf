provider "aws" {
  region  = "us-east-1"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket = "" 
    key    = ""
    region = ""
    profile= ""
  }
}


/*
terraform {
 backend "s3" {
    bucket         = "labchallenge-pipeline-state"
    key            = "state/s3_kms_dynamodb.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "alias/labchallenge-pipeline-state"
    dynamodb_table = "labchallenge-pipeline-state"
 }
}
*/
