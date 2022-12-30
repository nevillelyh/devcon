#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

create_single() {
    catalog="$1"
    echo "Creating Trino catalog $catalog"
    cp "/trino/catalog/$catalog.properties" "/etc/trino/catalog/$catalog.properties"
}

create_multi() {
    catalog="$1"
    shift
    if [[ $# -eq 1 ]]; then
        database="$1"
        echo "Creating Trino catalog ${catalog}"
        sed "s/{DATABASE}/$database/g" "/trino/catalog/$catalog.properties" \
            > "/etc/trino/catalog/${catalog}.properties"
    else
        for database in "$@"; do
            echo "Creating Trino catalog ${catalog}_${database}"
            sed "s/{DATABASE}/$database/g" "/trino/catalog/$catalog.properties" \
                > "/etc/trino/catalog/${catalog}_${database}.properties"
        done
    fi
}

init() {
    find /trino -type f -not -path "/trino/catalog/*" -print0 | while IFS= read -r -d $'\0' file; do
        dest="/etc$file"
        echo "Creating Trino configuration $dest"
        mkdir -p "$(dirname "$dest")"
        cp "$file" "$dest"
    done

    for catalog in "${TRINO_CATALOGS_ARRAY[@]}"; do
        case "$catalog" in
            cockroach)
                create_multi "$catalog" "${COCKROACH_DATABASES[@]}"
                ;;
            kafka)
                echo "Installing Kafka Protobuf schema provider"
                cd /usr/lib/trino/plugin/kafka
                # shellcheck disable=SC2012
                version=$(ls kafka-schema-registry-client-*.jar | sed 's/^kafka-schema-registry-client-\(.\+\).jar/\1/')
                wget -nv "https://packages.confluent.io/maven/io/confluent/kafka-protobuf-provider/$version/kafka-protobuf-provider-$version.jar"
                create_single "$catalog"
                ;;
            postgres)
                create_multi "$catalog" "${POSTGRES_PUBLIC_DATABASES[@]}"
                ;;
            *) create_single "$catalog"
                ;;
        esac
    done
}

if [[ ! -f "$HOME/init-complete" ]]; then
    init
    touch "$HOME/init-complete"
fi

/usr/lib/trino/bin/run-trino
