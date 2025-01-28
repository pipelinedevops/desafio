# Infrastructure as Code (IaC) - AWS Services

Este repositório contém as configurações de Terraform para gerenciar a infraestrutura AWS para serviços como AWS Glue, AWS Step Functions, e AWS EventBridge, entre outros, utilizando as melhores práticas de automação com GitHub Actions.

## Estrutura do Repositório

A estrutura do repositório é organizada por serviço e ambiente, facilitando a gestão e a escalabilidade das configurações:

```
/terraform
  /01-tfstate #root
    /tfstate-bucket #configurações do modulo  
```


objetivo:

cria bucket para state
criar chave kms para criptografia
criar dynamodb

#executar a primeira vez localmente propria estação

-atualizando o state: 
terraform init

terraform apply -refresh-only -auto-approve

#teste local

terraform init -reconfigure -backend-config="${{ env.BACKEND_CONFIG }}"
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file="${{ env.ENVIRONMENT_TFVARS }}"
terraform apply -auto-approve -lock=false -parallelism=10  -var-file="${{ env.ENVIRONMENT_TFVARS }}"

terraform init -reconfigure -backend-config=../environments/blackend-prd-01.tfvars
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file=../environments/prd-01.tfvars
terraform apply -auto-approve -lock=false -parallelism=10  -var-file=../environments/prd-01.tfvars



#primeiro deploy
1- executar

terraform init -reconfigure -backend-config=../../environments/blackend-prd-01.tfvars

2 - executar com o blackend comentado

3- alterar variaveis em /environments/prd-01.tfvars conforme o necessário

4- executar terraform plan -lock=false -parallelism=10 -out=plan.out -var-file=../../environments/prd-01.tfvars

5- executar e criar os recursos que vão ser usados para a pipeline com o blackend comentado

terraform apply -auto-approve -lock=false -parallelism=10  -var-file=../../environments/prd-01.tfvars

4- executar terraform init -reconfigure -backend-config=../../environments/blackend-prd-01.tfvars para migrar o state para o s3