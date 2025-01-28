
variable "bucket_prefix" {
  type = string
}

#usar em caso de não ser possivel usar o data
variable "org_id" {
  type = string
  
}

variable "tags" {
  type        = map(any)
  description = "tags do projeto s3"
  
}
