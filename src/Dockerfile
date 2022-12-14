FROM python:3.9.15-alpine3.15

ENV PYTHONUNBUFFERED 1

RUN apk --no-cache update \
    && apk add bash \ 
                gcc \
                g++ \
                libc-dev \
                musl-dev \
                libffi-dev \
                python3-dev \
                mariadb-dev  \
                make \
                cmake \
                unzip \
                curl-dev \
                autoconf \
                automake \
                libtool \
                libexecinfo-dev

WORKDIR /imbee
COPY poetry.lock pyproject.toml .
RUN pip install --upgrade pip \
    && pip install "poetry==1.2.2" \
    && poetry config virtualenvs.create false \
    && poetry install --no-root
COPY . /imbee/

ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

CMD [ "workers.mock_firebase_handler" ]
