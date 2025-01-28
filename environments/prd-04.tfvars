#nome do repositorio

cluster_name =  "lab-ecs"

reponame = "labchallenge"

imagetag = "v0.2"

imagename = "app"

ecs_servicename = "ecs_app"

##
#usar em caso de existir varias vpcs no ambiente

vpc_name = "vpc"

subnet_1a = "vpc-public-us-east-1a"

subnet_1b = "vpc-public-us-east-1b"

subnet_1c = "vpc-public-us-east-1c"

#subnet privada
#subnet_1a = "endpoint-us-east-1a"
#subnet_1b = "endpoint-us-east-1a"
#subnet_1c = "endpoint-us-east-1a"


#tags

tags = {
    Application = "ecs"
    project     = "lab_challenge"
    Owner       = "lab_challenge"
    Environment = "PRD"
    name = "ecs-cluster"
}
