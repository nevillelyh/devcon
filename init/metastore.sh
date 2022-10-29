#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

case "$METASTORE_DBTYPE" in
    mysql)
        /init/wait-for-it.sh mysql.devcon.io:3306 -s -t 0 -- echo "MySQL is up"
        ;;
    postgres)
        /init/wait-for-it.sh postgres.devcon.io:5432 -s -t 0 -- echo "PostgreSQL is up"
        ;;
    derby)
        ;;
esac

/apache/hive/bin/schematool -dbType "$METASTORE_DBTYPE" -validate || /apache/hive/bin/schematool -dbType "$METASTORE_DBTYPE" -initSchema
/apache/hive/bin/hive --service metastore
