#!/bin/bash
# shellcheck disable=SC2034

SERVICES=(metastore-hive metastore-iceberg mariadb minio mysql postgres scylla trino)

# derby, mysql, postgres
METASTORE_DBTYPE=derby

MINIO_BUCKETS=(hive iceberg)

MARIADB_DATABASES=(tpcds tpch)

MYSQL_PRIVATE_DATABASES=(hive iceberg)
MYSQL_PUBLIC_DATABASES=(tpcds tpch)

POSTGRES_PRIVATE_DATABASES=(hive iceberg)
POSTGRES_PUBLIC_DATABASES=(pgsql)

SCYLLA_KEYSPACES=(scylla tpcds tpch)

TRINO_CATALOGS=(bigquery hive iceberg mariadb mysql postgres scylla)

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
