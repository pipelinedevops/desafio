 resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.example.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 10
    capacity_provider = "FARGATE"
  }
}
 
################################################

resource "aws_cloudwatch_log_group" "example" {
  name = var.cluster_name

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "container" {
  name = "${var.cluster_name}-container"

  tags = var.tags
}


####################################################
####################################################
#iam to ecs cluster/task

# Definir uma função de IAM para o ECS

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags 
}

# Anexar políticas à função IAM
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_iam_role_policy_attachment" "CloudWatchLogs_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"

}

resource "aws_iam_role_policy_attachment" "cloud_map_ecs" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.cloud_map_policy.arn

}



resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecr_policy.arn

}



resource "aws_iam_policy" "cloud_map_policy" {
  name        = "CloudMapAccessPolicy"
  description = "Permissões para descoberta de serviços no Cloud Map"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "servicediscovery:DiscoverInstances",
          "servicediscovery:GetNamespace",
          "servicediscovery:ListNamespaces",
          "servicediscovery:CreateService",
          "servicediscovery:RegisterInstance"
        ],
        Resource = "*"
      }
    ]
  })
  tags = var.tags 
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecrAccessPolicy"
  description = "Permissões para o ecs usar o ecr"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
})
  tags = var.tags 
}

####################################################
####################################################
resource "aws_kms_key" "example" {
  description             = "example"
  deletion_window_in_days = 7

  tags = var.tags
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.example.id
  policy = jsonencode({
    Id = "ECSClusterFargatePolicy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "*"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow generate data key access for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example"
            ]
          }
        }
        Resource = "*"
      },
      {
        Sid    = "Allow grant creation permission for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:CreateGrant"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              "example"
            ]
          }
          "ForAllValues:StringEquals" = {
            "kms:GrantOperations" = [
              "Decrypt"
            ]
          }
        }
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}



 /*
resource "aws_service_discovery_private_dns_namespace" "example" {
  name        = var.ecs_servicename #"service-app"    # Nome do namespace
  description = "Namespace para ECS Service Connect"
  vpc         = data.aws_vpc.selected.id  #"vpc-xxxxxxxx"  # ID da VPC onde o namespace será usado

  tags = var.tags
}
*/