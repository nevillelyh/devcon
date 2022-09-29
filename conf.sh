#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(minio mysql metastore-hive metastore-iceberg postgres trino)

MINIO_BUCKETS=(hive iceberg)

MYSQL_PRIVATE_DATABASES=(hive iceberg)
MYSQL_PUBLIC_DATABASES=(tpcds tpch)

POSTGRES_PRIVATE_DATABASES=(hive iceberg)
POSTGRES_PUBLIC_DATABASES=(pgsql)

TRINO_CATALOGS=(bigquery hive iceberg mysql postgres)
