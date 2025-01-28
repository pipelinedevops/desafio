variable "imagename" {
   type = string
   description = "Nome do cofre"
   #default  =  "labchallenge"
 }

 variable "tags" {
  type        = map(any)
  description = "tags"

}

