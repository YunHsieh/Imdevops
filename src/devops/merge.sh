#!/bin/sh
set -x


DATABASE_URL=$(aws --region=ap-northeast-1 ssm get-parameter --name "/imbee/infra/database-url" --with-decryption --output text --query Parameter.Value)
DATABASE_NAME=$(aws --region=ap-northeast-1 ssm get-parameter --name "/imbee/infra/database-name" --with-decryption --output text --query Parameter.Value)
DATABASE_PASSWORD=$(aws --region=ap-northeast-1 ssm get-parameter --name "/imbee/infra/database-password" --with-decryption --output text --query Parameter.Value)
DATABASE_USERNAME=$(aws --region=ap-northeast-1 ssm get-parameter --name "/imbee/infra/database-username" --with-decryption --output text --query Parameter.Value)


docker run -it --rm \
    -e DATABASE_URL=$DATABASE_URL \
    -e DATABASE_NAME=$DATABASE_NAME \
    -e DATABASE_PASSWORD=$DATABASE_PASSWORD \
    -e DATABASE_USERNAME=$DATABASE_USERNAME \
    --entrypoint "alembic"  \
    imbee "upgrade" "head"


# docker run -it --rm \
#     -v $(pwd):/imbee \
#     --entrypoint /bin/bash imbee 


# docker run -it --rm --entrypoint "/usr/local/bin/alembic upgrade head" \
#     -e DATABASE_URI=${DATABASE_URI} \
#     imbee
