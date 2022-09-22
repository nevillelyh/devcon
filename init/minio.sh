#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh minio.devcon.io:9000 -s -t 0 -- echo "MinIO is up"

mc alias set minio http://minio.devcon.io:9000 minioadmin minioadmin
mc admin user add minio minio-key minio-secret
mc admin policy set minio readwrite user=minio-key

if [ -n "${MINIO_BUCKETS:-}" ]; then
    for bucket in "${MINIO_BUCKETS[@]}"; do
        if ! mc ls "minio/$bucket" &> /dev/null; then
            echo "Creating MinIO bucket $bucket"
            mc mb "minio/$bucket"
        fi
    done
fi
