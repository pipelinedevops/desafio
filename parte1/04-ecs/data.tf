data "aws_caller_identity" "current" {}

data "aws_ecr_image" "service_image" {
  repository_name = var.reponame #"my/service"
  image_tag       = var.imagetag  #"latest"
}
##############################################################
#usar em caso de existir varias vpcs no ambiente
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"] #["vpc"] # insert values here
  }
}


data "aws_subnets" "public-us-east-1a" {
    filter {
    name   = "tag:Name"
    values = ["${var.subnet_1a}"] # insert values here
  }
}


data "aws_subnets" "public-us-east-1b" {
    filter {
    name   = "tag:Name"
    values = ["${var.subnet_1b}"] # insert values here
  }
}

data "aws_subnets" "public-us-east-1c" {
    filter {
    name   = "tag:Name"
    values = ["${var.subnet_1c}"] # insert values here
  }
}

###############
#data "aws_vpc" "selected" {
  #id = var.vpc_id #filtro se houver
#}


/*
data "aws_subnets" "endpoint-us-east-1a" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1a"] # insert values here
  }
}

data "aws_subnets" "endpoint-us-east-1b" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1b"] # insert values here
  }
}

data "aws_subnets" "endpoint-us-east-1c" {
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1c"] # insert values here
  }
}
*/
##
#publico
/*
data "aws_subnets" "public-us-east-1a" {
    filter {
    name   = "tag:Name"
    values = ["vpc-public-us-east-1a"] # insert values here
  }
}

data "aws_subnets" "public-us-east-1b" {
    filter {
    name   = "tag:Name"
    values = ["vpc-public-us-east-1b"] # insert values here
  }
}

data "aws_subnets" "public-us-east-1c" {
    filter {
    name   = "tag:Name"
    values = ["vpc-public-us-east-1c"] # insert values here
  }
}
*/


###########testes
/*
data "aws_route_tables" "padrao" {
  vpc_id = data.aws_vpc.selected.id

}

data "aws_route_tables" "us-east-1a" {
  vpc_id = data.aws_vpc.selected.id
    
  filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1a"] # insert values here
  }
}

data "aws_route_tables" "us-east-1b" {
     vpc_id = data.aws_vpc.selected.id
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1b"] # insert values here
  }
}


data "aws_route_tables" "us-east-1c" {
     vpc_id = data.aws_vpc.selected.id
    filter {
    name   = "tag:Name"
    values = ["vpc-intra-us-east-1c"] # insert values here
  }
}
*/
