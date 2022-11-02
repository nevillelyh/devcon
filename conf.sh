#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(metastore-hive metastore-iceberg mariadb minio mongo mysql postgres scylla trino)

# derby, mysql, postgres
export METASTORE_DBTYPE=${METASTORE_DBTYPE:-derby}

MINIO_BUCKETS=(hive iceberg)

MYSQL_PRIVATE_DATABASES=(hive iceberg)

POSTGRES_PRIVATE_DATABASES=(hive iceberg)
POSTGRES_PUBLIC_DATABASES=(pgsql)

SCYLLA_KEYSPACES=(scylla tpcds tpch)

TRINO_CATALOGS=(bigquery hive iceberg mariadb mongo mysql postgres scylla)

export MARIADB_PORT=${MARIADB_PORT:-3306}
export METASTORE_HIVE_PORT=${METASTORE_HIVE_PORT:-9083}
export METASTORE_ICEBERG_PORT=${METASTORE_ICEBERG_PORT:-9084}
export MINIO_API_PORT=${MINIO_API_PORT:-9000}
export MINIO_UI_PORT=${MINIO_UI_PORT:-9001}
export MONGO_PORT=${MONGO_PORT:-27017}
export MONGO_EXPRESS_PORT=${MONGO_EXPRESS_PORT:-8081}
export MYSQL_PORT=${MYSQL_PORT:-3307}
export POSTGRES_PORT=${POSTGRES_PORT:-5432}
export SCYLLA_PORT=${SCYLLA_PORT:-9042}
export TRINO_PORT=${TRINO_PORT:-8080}

############################################################

bindir="$(dirname "$(readlink -f "$0")")"
basedir="$(readlink -f "$bindir/..")"

check_biguqery() {
    for catalog in "${TRINO_CATALOGS[@]}"; do
        if [[ "$catalog" == "bigquery" ]] && [[ ! -f "$basedir/trino/secrets/bigquery.json" ]]; then
            echo "Missing BigQuery secret key: trino/secrets/bigquery.json"
            (( errors++ ))
        fi
    done
}

check_all() {
    errors=0
    check_biguqery
    if [[ "$errors" -ne 0 ]]; then
        exit 1
    fi
}

if [[ ! -f /.dockerenv ]]; then
    check_all
fi
