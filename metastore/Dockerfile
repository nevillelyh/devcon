FROM azul/zulu-openjdk-alpine:8-latest
ARG hadoop_version=3.3.4
ARG hive_version=3.1.3
ARG mysql_version=8.0.31
ARG postgres_version=42.5.0

RUN apk add --no-cache bash curl procps

RUN adduser -D metastore
RUN mkdir /apache
RUN chown metastore /apache

USER metastore

WORKDIR /apache
RUN mkdir hadoop
RUN curl -fsSL https://dlcdn.apache.org/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz | \
    tar -C hadoop --strip-components 1 -xz
RUN mkdir hive
RUN curl -fsSL https://dlcdn.apache.org/hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz | \
    tar -C hive --strip-components 1 -xz
RUN curl -fsSL https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.31/mysql-connector-j-${mysql_version}.jar \
    -o hive/lib/mysql-connector-j-${mysql_version}.jar
RUN curl -fsSL https://jdbc.postgresql.org/download/postgresql-${postgres_version}.jar \
    -o hive/lib/postgresql-${postgres_version}.jar

ENV HADOOP_HOME=/apache/hadoop
ENV HIVE_HOME=/apache/hive

WORKDIR /home/metastore
CMD /apache/hive/bin/hive --service metastore
