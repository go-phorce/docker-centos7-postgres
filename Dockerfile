# This image is published at dva-registry.internal.salesforce.com/dva/stampy_dva_image
FROM centos:centos7

# Adding the package path to local
ENV LANG=en_US.UTF-8
ENV PATH=$PATH:/usr/pgsql-11/bin
ENV PG_CONFDIR="/var/lib/pgsql"
ENV PGDATA="/var/lib/pgsql/data"

# create local repo
RUN mkdir -p /sql-localrepo
ADD ./postgresql-setup.sh /usr/bin/postgresql-setup.sh
ADD ./start_postgres.sh /start_postgres.sh
ADD ./postgresql.conf /var/lib/pgsql/postgresql.conf

RUN yum -y install \
        which \
        sudo \
        pwgen \
        createrepo \
        systemd-sysv \
        libicu \
        libicuuc \
        libicui18n \
        yum-utils

# Cleanup
RUN yum -y clean all && yum update -y

ADD ./repodata/ /sql-localrepo
ADD ./sql-localrepo.repo /etc/yum.repos.d/sql-localrepo.repo

RUN createrepo -v /sql-localrepo/ && \
    yum repolist && \
    yum -y install --disablerepo="*" --enablerepo="sql-localrepo" \
        postgresql11-server

RUN ls -aR /usr/pgsql-* && \
    chmod a+x /usr/bin/* && \
    chmod a+x /start_postgres.sh && \
    chown -R postgres.postgres /var/lib/pgsql && \
    chown postgres.postgres /start_postgres.sh && \
    echo "host    all             all             0.0.0.0/0               trust" >> /var/lib/pgsql/pg_hba.conf

RUN /usr/bin/postgresql-setup.sh initdb || cat /var/lib/pgsql/initdb.log

VOLUME ["/var/lib/pgsql","/scripts/pgsql"]

EXPOSE 5432

CMD ["/bin/bash", "/start_postgres.sh"]
