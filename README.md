# docker-centos7-postgres

Docker images for Postgres SQL

Cloned from https://github.com/CentOS/CentOS-Dockerfiles/tree/master/postgres/centos7

## Setup

To build the image

```.sh
docker build --no-cache -t ekspand/docker-centos7-postgres .
```

## Launching PostgreSQL

Quick Start (not recommended for production use)

```.sh
docker run -it --rm --volumes-from=postgresql <yourname>/postgres sudo -u postgres -H psql
```

## Creating a database at launch

You can create a postgresql superuser at launch by specifying `POSTGRES_USER` and `POSTGRES_PASSWORD` variables. You may also create a database by using `POSTGRES_DB`.

```.sh
docker run --name postgresql -d \
-e 'POSTGRES_USER=username' \
-e 'POSTGRES_PASSWORD=ridiculously-complex_password1' \
-e 'POSTGRES_DB=my_database' \
<yourname>/postgresql
```

To connect to your database with your newly created user:

```.sh
psql -U username -h $(docker inspect --format {{.NetworkSettings.IPAddress}} postgresql)
```