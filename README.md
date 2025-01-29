# desafio


Para configurar o pipeline em questão é necessário:

1- fazer clone do repositorio

2- fazer login na aws

3- criar user iam para a pipeline com administrator acess na conta aws

3- configurar as variaveis secrets no repositorio conforme o ambiente desejado conforme o arquivos .github/workflows/xxxx.yml

para prd são esses

secrets.TF_AWS_LAB_ID

secrets.TF_AWS_LAB_KEY

4- configurar a variavel de região desejada no arquivo .github/workflows/xxxx.yml

5- configurar as variaveis de ambiente para a criação do repositorio/image name do ecr no arquivo .github/workflows/ecr.yml
no momento são esses:

repo_name: labchallenge  #nome do repositorio
image_name: app #nome da imagem
tag_name: v0.2  #tag name 

6- abrir a pasta parte2/01-tfstate

7 -  fazer login na aws

8- executar as intruções conforme o topico no arquivo readme  #primeiro deploy

9- ajustar o blackends definidos nos arquivos"/environments/blackend-prd-xxx.tfvars" que foi criado no passo parte2/01-tfstate

10- ajustar os arquivos /environments/prd-xx.tfvars conforme comentado em cada um dos arquivos

11 - fazer push para executar as pipelines (na primeira execução)

obs: a primeira exeução apenas o repositorio vai ser criado com seus requisitos, na segunda os recursos do ecs devem  ser criados com sucesso

Solução:


-Por escolha de arquitetura / custo foi criado um ambiente usando subnet publica e fargate para não usar nat/vpc endpoint oque tornaria mais caro criar/manter o ambiente

-Foi escrito um ambiente iac pensando em um padrão de organização. mas, é possivel usar em outros tipos de ambiente

-Para monitoramento foi usado cloudwach habilitado junto ao ecs para os containers e logs