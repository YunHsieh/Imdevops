#!/bin/sh
set -x

# build docker iamge
docker build -t imbee .

# login to ecr awscliv2
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ECR_IMBEE_REPO_URL

# push image to ecr
export REPOSITORY=$(aws ssm get-parameters --region ap-northeast-1 --names /at-ut/v1/ecr/uri/django-shareable --query "Parameters[0]"."Value" | sed -e 's/^"//' -e 's/"$//')
docker tag imbee:latest $ECR_IMBEE_REPO_URL:latest
docker push $ECR_IMBEE_REPO_URL:latest
