#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh scylla.devcon.io:9042 -s -t 0 -- echo "Scylla is up"

for ks in "${SCYLLA_KEYSPACES[@]}"; do
    cqlsh scylla.devcon.io --execute="CREATE KEYSPACE IF NOT EXISTS $ks WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };"
done
