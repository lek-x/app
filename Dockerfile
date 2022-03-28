FROM python:3.9.10-alpine3.15
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    py3-pip \
    postgresql-dev \
    gcc \
    musl-dev \
    && rm -rf /var/cache/apk/*
COPY requirements.txt /
WORKDIR /app
ADD static ./static
ADD templates ./templates
COPY ["hello.py", "init_db.py", "entrypoint.sh", "./"]
RUN chmod +x /app/entrypoint.sh \
    && pip install --upgrade pip setuptools \
    && pip install -r /requirements.txt \
    && pip cache purge
EXPOSE 5000
ENV dname=$dbname
ENV duser=$duser
ENV dpass=$dpass
ENV dbhost=$dbhost
ENV prt=$prt
ENTRYPOINT ["bash", "/app/entrypoint.sh"]

