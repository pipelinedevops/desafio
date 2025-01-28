teste local

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

docker build -t app:v0.1 ../03-image/

docker tag app:v0.1 app

docker run  app:v0.1 app

docker run -p 8080:8080 app:v0.1

docker tag app:v0.1 $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/labchallenge:v0.1

docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/labchallenge:v0.1

