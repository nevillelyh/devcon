#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh cp-zookeeper.devcon.io:2181 -s -t 0 -- echo "Zookeeper is up"
/init/wait-for-it.sh cp-broker.devcon.io:29092 -s -t 0 -- echo "Kafka Broker is up"
/init/wait-for-it.sh cp-schema-registry.devcon.io:8081 -s -t 0 -- echo "Kafka Schema Registry is up"
/init/wait-for-it.sh cp-connect.devcon.io:8083 -s -t 0 -- echo "Kafka Connect is up"

sleep 5

# shellcheck disable=SC2002
cat /usr/share/confluent-hub-components/confluentinc-kafka-connect-datagen/etc/connector_users_protobuf.config | \
    sed 's@"value.converter.schema.registry.url": "http://localhost:8081",@"value.converter.schema.registry.url": "http://cp-schema-registry.devcon.io:8081",@' | \
    sed 's@"value.converter.schemas.enable": "false",@"value.converter.schemas.enable": "true",@' | \
    curl -fsSL -X POST -H "Content-Type: application/json" --data "@-" http://cp-connect.devcon.io:8083/connectors
