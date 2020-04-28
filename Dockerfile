FROM postgres:10.12
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y curl lzop pv daemontools locales \
        python3-pip python3-psycopg2 python3-six  \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && pip3 install patroni[consul]==1.6.5 \
    && mkdir -p /home/postgres && mkdir -p /home/patroni && mkdir /var/lib/postgresql/data/pgdata \
    && chown postgres:postgres /home/postgres \
    && chown postgres:postgres /home/patroni \
    && chown postgres:postgres /var/lib/postgresql/data/pgdata \
    && apt-get remove -y python3-pip \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /root/.cache && mkdir -p /etc/wal-g.d/env && chown postgres /etc/wal-g.d/env
RUN curl -L https://github.com/wal-g/wal-g/releases/download/v0.2.15/wal-g.linux-amd64.tar.gz | tar -xz -C /usr/local/bin
WORKDIR /home/postgres
COPY start.sh /start.sh
RUN chown postgres /start.sh && chmod +x /start.sh
USER postgres
EXPOSE 8008
CMD ["/start.sh", "patroni", "/home/patroni/patroni.yml"]
