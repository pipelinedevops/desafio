## KMS KEY - Encrypt resources created ###${var.name}/${var.project}/${var.environment}"
resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${var.bucket_prefix}" 
  target_key_id = aws_kms_key.kms_key.key_id
}

resource "aws_kms_key" "kms_key" {
  #checkov:skip=CKV_AWS_33:The policy has the OrgId condition
  description         = "KMS Key for tfstate bucket"
  is_enabled          = true
  enable_key_rotation = true
  key_usage           = "ENCRYPT_DECRYPT"
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "kms-key"
    Statement = [
      {
        Sid    = "EnableKeyAdmin"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "EnableKeyUsage"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
        ]
        Resource = "*"
      },
      {
        "Sid" : "AllowOrg",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:PrincipalOrgID" : "${var.org_id}" 
          }
        }
      }
    ]
  })
  tags = var.tags
}
#data.aws_organizations_organization.this.id
resource "aws_s3_bucket" "s3_bucket_tfstate" {
  #checkov:skip=CKV2_AWS_62:This bucket is intended to store logs
  #checkov:skip=CKV_AWS_18:This bucket is intended to store logs
  #checkov:skip=CKV_AWS_144:This bucket is intended to store logs
  bucket = "${var.bucket_prefix}"
  tags = var.tags
}

/*
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_tfstate_lifecicle" {
  bucket = aws_s3_bucket.s3_bucket_tfstate.id

  rule {
    id = "Remove replicated logs after 60 days"

    noncurrent_version_expiration {
      noncurrent_days = 60
    }

    expiration {
      days = 60
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 6
    }

    status = "Enabled"
  }
}
*/

resource "aws_s3_bucket_versioning" "s3_bucket_tfstate_versioning" {
  bucket = aws_s3_bucket.s3_bucket_tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_tfstate_server_side_encrypt" {
  bucket = aws_s3_bucket.s3_bucket_tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_tfstate_block_public" {
  bucket = aws_s3_bucket.s3_bucket_tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/*
resource "aws_s3_bucket_policy" "s3_bucket_tfstate_access_policy" {
  #checkov:skip=CKV_AWS_70:The policy has the principal condition
  bucket = aws_s3_bucket.s3_bucket_tfstate.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HTTPSOnly",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.s3_bucket_tfstate.arn}/*",
        "${aws_s3_bucket.s3_bucket_tfstate.arn}"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": false
        }
      }
    },
    {
      "Sid": "AllowAccount",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.s3_bucket_tfstate.arn}/*",
        "${aws_s3_bucket.s3_bucket_tfstate.arn}"
      ],
      "Condition": {
        "StringEquals":{
            "aws:PrincipalOrgID": "${var.org_id}"
          }        
      }
    }
  ]
}
EOF
}
*/
#"${data.aws_organizations_organization.this.id}"

resource "aws_dynamodb_table" "dynamodb" {
  name = "${var.bucket_prefix}"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
}


################################
#ACL

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket =  aws_s3_bucket.s3_bucket_tfstate.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket.s3_bucket_tfstate]

  bucket =  aws_s3_bucket.s3_bucket_tfstate.id
  access_control_policy {
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
     
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}