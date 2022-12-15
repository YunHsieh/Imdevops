terraform init
echo 'yes' | terraform apply
cd ./src
./devops/build-ecr.sh
./devops/merge.sh
sls deploy
