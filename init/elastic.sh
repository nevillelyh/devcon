#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh elastic.devcon.io:9200 -s -t 0 -- echo "Elasticsearch is up"

curl -fsSL -X POST -u "elastic:elasticpass" -H "Content-Type: application/json" \
    http://elastic.devcon.io:9200/_security/user/kibana/_password -d '{"password":"kibanapass"}'
