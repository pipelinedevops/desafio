
bucket         = "labchallenge-pipeline-state"
key            = "state/s3_kms_dynamodb.tfstate"
region         = "us-east-1"
encrypt        = true
kms_key_id     = "alias/labchallenge-pipeline-state"
dynamodb_table = "labchallenge-pipeline-state"

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