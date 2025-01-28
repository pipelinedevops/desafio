#nome do repositorio

#nome do cluster ecs

cluster_name =  "lab-ecs"

#repository name ecr

reponame = "labchallenge"

#tagname ecr

imagetag = "v0.2"

#image name acr

imagename = "app"

#nome do service ecs
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
