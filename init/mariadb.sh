#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh mariadb.devcon.io:3306 -s -t 0 -- echo "MariaDB is up"

cmd="mysql --host=mariadb.devcon.io --user=root --password=mariadbpass"
user="mariadb"
pass="mariadbpass"
$cmd --execute="CREATE USER IF NOT EXISTS '$user'@'%' IDENTIFIED BY '$pass';"
for db in "${MARIADB_DATABASES[@]}"; do
    echo "Creating MariaDB database $db: user=$user password=$pass"
    {
        echo "CREATE DATABASE IF NOT EXISTS $db;"
        echo "GRANT ALL PRIVILEGES ON $db.* TO '$user'@'%';"
    } > "$HOME/init.sql"
    $cmd < "$HOME/init.sql"
    rm "$HOME/init.sql"
done
