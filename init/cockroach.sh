#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

[[ -f $HOME/init-complete ]] && exit 0

/init/wait-for-it.sh "cockroach1.devcon.io:26257" -s -t 0 -- echo "CockroachDB is up"

/cockroach/cockroach init --insecure --host cockroach1.devcon.io
for database in "${COCKROACH_DATABASES[@]}"; do
    /cockroach/cockroach workload init "$database" \
        postgresql://root@cockroach1.devcon.io:26257?sslmode=disable
done

touch "$HOME/init-complete"
