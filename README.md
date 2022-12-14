# imbee_hw

I used tools as the below:
- terraform for aws
- python ormar model
- firebase

System recommand MacOS
## Prerequisite
- [awscliv2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [npm](https://nodejs.org/en/download/)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
```
npm install -g serverless
```

Start the whole project's script
```
terraform init
echo yes | terraform apply
cd ./src
./devops/build-ecr.sh
./devops/merge.sh
sls deploy
cd ..
```
