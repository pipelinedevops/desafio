variable "cluster_name" {
   type = string
   description = "Nome do cluster"
   #default  =  "labchallenge"
 }

variable "ecs_servicename" {
   type = string
   description = "Nome do cluster"
   #default  =  "labchallenge"
 }


variable "reponame" {
   type = string
   description = "Nome do repositório"
   #default  =  "labchallenge"
 }

 variable "imagetag" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

variable "imagename" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

######################################
#subnets /vpc
#usar em caso de existir varias vpcs no ambiente


variable "vpc_name" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

variable "subnet_1a" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

variable "subnet_1b" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }


variable "subnet_1c" {
   type = string
   description = "Nome tag"
   #default  = "v" #"labchallenge"
 }

#########################


 variable "tags" {
  type        = map(any)
  description = "tags"

}

