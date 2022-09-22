#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(minio mysql metastore-hive metastore-iceberg)

MINIO_BUCKETS=(hive iceberg)

MYSQL_DATABASES=(hive iceberg)
