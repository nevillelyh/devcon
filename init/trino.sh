#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

find /trino -type f -not -path "/trino/catalog/*" -print0 | while IFS= read -r -d $'\0' file; do
    dest="/etc$file"
    echo "Creating Trino configuration $dest"
    mkdir -p "$(dirname "$dest")"
    cp "$file" "$dest"
done

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

for catalog in "${TRINO_CATALOGS[@]}"; do
    case "$catalog" in
        cockroach)
            create_multi "$catalog" "${COCKROACH_DATABASES[@]}"
            ;;
        postgres)
            create_multi "$catalog" "${POSTGRES_PUBLIC_DATABASES[@]}"
            ;;
        *) create_single "$catalog"
            ;;
    esac
done

/usr/lib/trino/bin/run-trino
