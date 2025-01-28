
################################################
# Criar um cluster ECS
resource "aws_ecs_cluster" "example" {
  name = var.cluster_name #"example-ecs-cluster"
 
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.example.arn
      logging    = "OVERRIDE"

      log_configuration {
        #cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.example.name
      }
    }

  }

  tags = var.tags
    depends_on = [
    aws_kms_key_policy.example
  ]
}

############################################################

# Configurar uma definição de tarefa ECS
resource "aws_ecs_task_definition" "example" {
  family                   = var.imagename #"example-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # 0.25 vCPU
  memory                   = "512"  # 512 MiB

  container_definitions = jsonencode([
    {
      name      = "${var.reponame}" #"nginx"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.reponame}:${var.imagetag}" #"nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]

       logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.container.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "container"
        }
      }
      /*
       mountPoints = [
        {
          sourceVolume  = "volume"
          containerPath = "/usr/share/nginx/html"
        }
      ],
      */
    }
  ])


depends_on = [
    aws_ecs_cluster.example
  ]
  
}

##############################################
# Criar um serviço ECS

resource "aws_ecs_service" "example" {
  name            = var.ecs_servicename #"example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 3
  launch_type     = "FARGATE" #"FARGATE" #"FARGATE" "EC2" "EXTERNAL"
  availability_zone_rebalancing  = "ENABLED"
  deployment_maximum_percent = 200 #minimo 100
  deployment_minimum_healthy_percent = 50
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

/*
   alarms {
    enable   = true
    rollback = true
    alarm_names = [
      aws_cloudwatch_metric_alarm.example.alarm_name
    ]
  }
  */

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn #"arn:aws:elasticloadbalancing:us-east-1:340752805961:targetgroup/internal9090/0f674ee7668313cf" #aws_lb_target_group.ecs_tg.arn
    container_name   = var.reponame #"ecs-container"
    container_port   = 9090
  }

  deployment_circuit_breaker {
     enable   = true
     rollback  = true
  }
  
  network_configuration {
    #subnets         = ["${data.aws_subnets.endpoint-us-east-1a.ids[0]}", "${data.aws_subnets.endpoint-us-east-1b.ids[0]}", "${data.aws_subnets.endpoint-us-east-1c.ids[0]}"] # IDs das sub-redes existentes
    subnets         = ["${data.aws_subnets.public-us-east-1a.ids[0]}", "${data.aws_subnets.public-us-east-1b.ids[0]}", "${data.aws_subnets.public-us-east-1c.ids[0]}"] # IDs das sub-redes existentes
    
    security_groups = [
      aws_security_group.vpc_acesso.id,
      aws_security_group.acesso_service.id
    ] # ID do grupo de segurança existente
    
    assign_public_ip = true                # Auto-atribui IP público para a tarefa just fargate

  }

/*
service_connect_configuration {
    enabled = true
    namespace =   var.ecs_servicename #"service-app" Nome do namespace para Service Connect

  service {
      port_name        = "http"
      discovery_name   = "service-http"
      client_alias  {
          port           = 9090
          dns_name       = "http-alias"
        }
        
    }
}
*/

    tags = var.tags
    depends_on = [
    aws_ecs_cluster.example,
    aws_security_group.acesso_service,
    aws_security_group.acesso_service
  ]

}

#######
