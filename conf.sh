#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(minio mysql metastore-hive metastore-iceberg trino)

MINIO_BUCKETS=(hive iceberg)

MYSQL_DATABASES=(hive iceberg trino)

TRINO_CATALOGS=(hive iceberg mysql)
