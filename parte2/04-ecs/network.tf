
########################################
#alb


#sg nlb
  resource "aws_security_group" "vpc_nlb" {
  name   = "nlb_acesso"
  vpc_id =  data.aws_vpc.selected.id 

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "TCP"
    cidr_blocks =  ["0.0.0.0/0"] #[data.aws_vpc.vpc.cidr_block]  #
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block] # [data.aws_vpc.vpc.cidr_block] 
  }
  tags = var.tags
}

# Criar o Target Group
resource "aws_lb_target_group" "ecs_tg" {
  name     = "ecs-target-v2"
  port     = 9090
  protocol = "HTTP"
  target_type = "ip" 
  load_balancing_algorithm_type = "least_outstanding_requests" #round_robin least_outstanding_request weighted_random
  #load_balancing_anomaly_mitigation = "on"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = var.tags
}

##########################################
# Criar o Listener do Load Balancer
resource "aws_lb_listener" "ecs_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  tags = var.tags

  depends_on = [ aws_lb_target_group.ecs_tg ]
  
}

resource "aws_lb" "ecs_lb" {
  name               = "ecs-public"
  internal           = false
  load_balancer_type = "application"
  #enable_deletion_protection = true
  #enable_cross_zone_load_balancing = true #padrão
  dns_record_client_routing_policy = "any_availability_zone"
  security_groups = [
      aws_security_group.vpc_nlb.id
    ]

/*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

connection_logs {
   bucket  = aws_s3_bucket.lb_logs.id
   prefix  = "test-lb"
   enabled = true
}
*/
  subnets    = [ 
    "${data.aws_subnets.public-us-east-1a.ids[0]}", "${data.aws_subnets.public-us-east-1b.ids[0]}", "${data.aws_subnets.public-us-east-1c.ids[0]}"
    ] # IDs das sub-redes existentes

  tags = var.tags


  depends_on = [ 
    aws_security_group.vpc_nlb
    ]
}


##################################
##################################

#sg ecs
  resource "aws_security_group" "vpc_acesso" {
  name   = "vpc_acesso"
  vpc_id =  data.aws_vpc.selected.id 

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #[data.aws_vpc.vpc.cidr_block]  #["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block] # [data.aws_vpc.vpc.cidr_block] 
  }
  tags = var.tags
}

##securanca public
  resource "aws_security_group" "acesso_service" {
  name   = "acesso_services"
  vpc_id =  data.aws_vpc.selected.id 

  # access from the VPC
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #["0.0.0.0/0"] #[data.aws_vpc.selected.cidr_block] # #permite requisição de fora do nlb
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks =  [data.aws_vpc.selected.cidr_block] #["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # [data.aws_vpc.vpc.cidr_block] 
  }
  tags = var.tags
}


/*
# Criar Elastic IP para o NAT Gateway
resource "aws_eip" "nat_eip-1a" {
  vpc = true
  tags = var.tags
}


resource "aws_nat_gateway" "us-east-1a" {
  connectivity_type = "public" #"private"
  allocation_id = aws_eip.nat_eip-1a.id  
  subnet_id         = data.aws_subnets.public-us-east-1a.ids[0] #data.aws_subnets.endpoint-us-east-1a.ids[0]
  #secondary_private_ip_address_count = 1
  depends_on = [ 
    aws_eip.nat_eip-1a
    ]
  tags = var.tags
}
*/


##
/*
resource "aws_eip" "nat_eip-1b" {
  vpc = true
  tags = var.tags
}



resource "aws_nat_gateway" "us-east-1b" {
  connectivity_type = "public" #"private"
  allocation_id = aws_eip.nat_eip-1b.id  
  subnet_id         = data.aws_subnets.endpoint-us-east-1b.ids[0]
  #secondary_private_ip_address_count = 1
  depends_on = [ 
    aws_eip.nat_eip-1a,
    aws_eip.nat_eip-1b,
    aws_eip.nat_eip-1c 
    ]
  tags = var.tags
}

###

resource "aws_eip" "nat_eip-1c" {
  vpc = true
  tags = var.tags
}

#route_table_ids = data.aws_route_tables.loki.ids 


resource "aws_nat_gateway" "us-east-1c" {
  connectivity_type = "public" #"private"
  allocation_id = aws_eip.nat_eip-1c.id  
  subnet_id         = data.aws_subnets.endpoint-us-east-1c.ids[0]
  #secondary_private_ip_address_count = 1
  depends_on = [ 
    aws_eip.nat_eip-1a,
    aws_eip.nat_eip-1b,
    aws_eip.nat_eip-1c 
    ]
  tags = var.tags
}

*/

#tabela de rotas
/*
# Criar Tabela de Rotas para a Subnet Privada
resource "aws_route_table" "us-east-1a" {
  vpc_id = data.aws_vpc.selected.id #aws_vpc.example_vpc.id


  route {
    cidr_block = data.aws_vpc.selected.cidr_block #"10.0.0.0/16"  # Faixa de IP da VPC
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-1a.id
    #gateway_id = aws_internet_gateway.example.id
  }

  tags = var.tags

}
*/

#routa tables association

/*
resource "aws_route_table_association" "us-east-1a" {
  subnet_id      = data.aws_subnets.endpoint-us-east-1a.ids[0] #data.aws_subnets.endpoint-us-east-1a.id
  route_table_id = aws_route_table.us-east-1a.id
  
}
*/

/*
# Adicionar Rota para o NAT Gateway na Tabela de Rotas
resource "aws_route" "us-east-1c" {
  route_table_id         = aws_route_table.us-east-1a.id #aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"  # Todo o tráfego para a Internet
  nat_gateway_id         = aws_nat_gateway.us-east-1a.id

}
*/


###

/*

resource "aws_route_table" "us-east-1b" {
  vpc_id = data.aws_vpc.selected.id #aws_vpc.example_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-1b.id
    #gateway_id = aws_internet_gateway.example.id
  }
  tags = var.tags
}


resource "aws_route_table" "us-east-1c" {
  vpc_id = data.aws_vpc.selected.id #aws_vpc.example_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-1c.id
    #gateway_id = aws_internet_gateway.example.id
  }

  tags = var.tags
}
*/
