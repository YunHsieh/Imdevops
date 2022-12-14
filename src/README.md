# Notification service


## Update model
```bash
alembic revision --autogenerate -m "{Create a migrations file}"
alembic upgrade head
```


## local start up
```bash
docker-compose build
docker-compose up -d

# into the bash
docker-compose run --rm -v $(pwd):/imbee/ --entrypoint /bin/bash app
```

## deploy
```
./devops/build-ecr.sh
./devops/merge.sh
sls deploy
```

# Reference
[alembic document](https://alembic.sqlalchemy.org/en/latest/tutorial.html)
