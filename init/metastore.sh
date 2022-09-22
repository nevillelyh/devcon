#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh mysql.devcon.io:3306 -s -t 0 -- echo "MySQL is up"

/apache/hive/bin/schematool -dbType mysql -validate || /apache/hive/bin/schematool -dbType mysql -initSchema
/apache/hive/bin/hive --service metastore
