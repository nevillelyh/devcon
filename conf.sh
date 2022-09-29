#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(minio mysql metastore-hive metastore-iceberg trino)

MINIO_BUCKETS=(hive iceberg)

MYSQL_PRIVATE_DATABASES=(hive iceberg)
MYSQL_PUBLIC_DATABASES=(tpcds tpch)

TRINO_CATALOGS=(bigquery hive iceberg mysql)
