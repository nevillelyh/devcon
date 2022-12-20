#!/bin/bash
# shellcheck disable=SC2034

# Override with SERVICES=service1,service2,...
SERVICES_ARRAY=(cockroach kafka metastore-hive metastore-iceberg mariadb minio mongo mysql postgres scylla trino)

# Override with TRINO_CATALOGS=catalog1,catalog2,...
TRINO_CATALOGS_ARRAY=(bigquery cockroach hive iceberg kafka mariadb mongo mysql postgres scylla)

# Supported database types: derby, mysql, postgres
export METASTORE_DBTYPE=${METASTORE_DBTYPE:-derby}

COCKROACH_DATABASES=(bank intro kv movr startrek tpcc ttllogger ycsb)

MINIO_BUCKETS=(hive iceberg)

MYSQL_PRIVATE_DATABASES=(hive iceberg)

POSTGRES_PRIVATE_DATABASES=(hive iceberg)
POSTGRES_PUBLIC_DATABASES=(pgsql)

SCYLLA_KEYSPACES=(scylla tpcds tpch)

export COCKROACH_PORT=${COCKROACH_PORT:-26257}
export COCKROACH_UI_PORT=${COCKROACH_UI_PORT:-8082}
export CP_ZOOKEEPER_PORT=${CP_ZOOKEEPER_PORT:-2181}
export CP_BROKER_PORT=${CP_BROKER_PORT:-9092}
export CP_SCHEMA_REGISTRY_PORT=${CP_SCHEMA_REGISTRY_PORT:-8081}
export CP_CONTROL_CENTER_PORT=${CP_CONTROL_CENTER_PORT:-9021}
export CP_CONNECT_PORT=${CP_CONNECT_PORT:-8083}
export MARIADB_PORT=${MARIADB_PORT:-3306}
export METASTORE_HIVE_PORT=${METASTORE_HIVE_PORT:-9083}
export METASTORE_ICEBERG_PORT=${METASTORE_ICEBERG_PORT:-9084}
export MINIO_API_PORT=${MINIO_API_PORT:-9000}
export MINIO_UI_PORT=${MINIO_UI_PORT:-9001}
export MONGO_PORT=${MONGO_PORT:-27017}
export MONGO_EXPRESS_PORT=${MONGO_EXPRESS_PORT:-8084}
export MYSQL_PORT=${MYSQL_PORT:-3307}
export POSTGRES_PORT=${POSTGRES_PORT:-5432}
export SCYLLA_PORT=${SCYLLA_PORT:-9042}
export TRINO_PORT=${TRINO_PORT:-8080}

############################################################

join() {
    first=${1-}
    if shift; then
        printf "%s" "$first" "${@/#/,}"
    fi
}

SERVICES=${SERVICES:-}
if [[ -n "$SERVICES" ]]; then
    IFS="," read -r -a SERVICES_ARRAY <<< "$SERVICES"
fi

TRINO_CATALOGS=${TRINO_CATALOGS:-}
if [[ -n "$TRINO_CATALOGS" ]]; then
    IFS="," read -r -a TRINO_CATALOGS_ARRAY <<< "$TRINO_CATALOGS"
fi

TRINO_CATALOGS="$(join "${TRINO_CATALOGS_ARRAY[@]}")"
export TRINO_CATALOGS

############################################################

bindir="$(dirname "$(readlink -f "$0")")"
basedir="$(readlink -f "$bindir/..")"

contains() {
    needle=$1
    shift
    for x in "$@"; do
        [[ "$x" == "$needle" ]] && return 0
    done
    return 1
}

error() {
    echo "[ERROR] $1"
    (( errors++ ))
    return 0
}

check_dbtype() {
    if ! contains "metastore-hive" "${SERVICES_ARRAY[@]}" && ! contains "metastore-iceberg" "${SERVICES_ARRAY[@]}"; then
        return
    fi
    case "$METASTORE_DBTYPE" in
        derby) ;;
        mysql)
            if ! contains mysql "${SERVICES_ARRAY[@]}"; then
                error "METASTORE_DBTYPE=$METASTORE_DBTYPE depends on mysql service"
            fi
            ;;
        postgres)
            if ! contains postgres "${SERVICES_ARRAY[@]}"; then
                error "METASTORE_DBTYPE=$METASTORE_DBTYPE depends on postgres service"
            fi
            ;;
    esac
}

check_catalogs() {
    if ! contains trino "${SERVICES_ARRAY[@]}"; then
        return
    fi
    for catalog in "${TRINO_CATALOGS_ARRAY[@]}"; do
        case "$catalog" in
            bigquery)
                if [[ ! -f "$basedir/trino/secrets/bigquery.json" ]]; then
                    error "Missing BigQuery secret key: trino/secrets/bigquery.json"
                fi
                ;;
            hive|iceberg)
                if ! contains "metastore-$catalog" "${SERVICES_ARRAY[@]}"; then
                    error "$catalog catalog depends on metastore-$catalog service"
                fi
                ;;
            *)
                if ! contains "$catalog" "${SERVICES_ARRAY[@]}"; then
                    error "$catalog catalog depends on $catalog service"
                fi
                ;;
        esac
    done
}

check_all() {
    errors=0
    check_dbtype
    check_catalogs
    if [[ "$errors" -ne 0 ]]; then
        exit 1
    fi
}

if [[ ! -f /.dockerenv ]]; then
    check_all
fi
