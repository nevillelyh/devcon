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

for catalog in "${TRINO_CATALOGS[@]}"; do
    echo "Creating Trino catalog $catalog"
    cp "/trino/catalog/$catalog.properties" "/etc/trino/catalog/$catalog.properties"
done

/usr/lib/trino/bin/run-trino
