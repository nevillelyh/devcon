#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh mongo.devcon.io:27017 -s -t 0 -- echo "MongoDB is up"

/docker-entrypoint.sh
