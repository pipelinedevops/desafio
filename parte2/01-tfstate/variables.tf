#nome do bucket a ser criado 
variable "bucketprefix" {
  type = string
  #default  = "labchallenge-pipeline-state"
}

#usar em caso de não for possivel usar o data
#valor usado para policy do s3 pode ser obtido pelo aws cli aws organizations list-roots
variable "orgid" {
  type = string
  #default  = "o-0ul8usqby7"
}


#tags para serem usadas no module
 variable "tags" {
  type        = map(any)
  description = "tags"
}

#tags para serem usadas no module
/*
locals {     
  
   tags = {
    Application = "state"
    project     = "lab_challenge"
    Owner       = "lab_challenge"
    Environment = "PRD"
  }

  }
*/