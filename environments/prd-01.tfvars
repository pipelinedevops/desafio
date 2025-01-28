#nome do bucket 
bucketprefix = "labchallenge-pipeline-state"


#usar em caso de não for possivel usar o data
#valor usado para policy do s3 pode ser obtido pelo aws cli aws organizations list-roots

orgid = "o-0ul8usqby7"

#tags

tags = {
    Application = "state"
    project     = "lab_challenge"
    Owner       = "lab_challenge"
    Environment = "PRD"
}
