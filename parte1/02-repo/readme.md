#teste local

terraform init -reconfigure -backend-config="${{ env.BACKEND_CONFIG }}"
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file="${{ env.ENVIRONMENT_TFVARS }}"
terraform apply -auto-approve -lock=false -parallelism=10  -var-file="${{ env.ENVIRONMENT_TFVARS }}"

terraform init -reconfigure -backend-config=../environments/blackend-prd-02.tfvars
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file=../environments/prd-02.tfvars
terraform apply -auto-approve -lock=false -parallelism=10  -var-file=../environments/prd-02.tfvars