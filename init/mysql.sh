#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh mysql.devcon.io:3306 -s -t 0 -- echo "MySQL is up"

cmd="mysql --host=mysql.devcon.io --user=root --password=mysqlpass"
for db in "${MYSQL_PRIVATE_DATABASES[@]}"; do
    user="$db"
    pass="${db}pass"

    echo "Creating MySQL database $db: user=$user password=$pass"
    {
        echo "CREATE DATABASE IF NOT EXISTS $db;"
        echo "CREATE USER IF NOT EXISTS '$user'@'%' IDENTIFIED BY '$pass';"
        echo "GRANT ALL PRIVILEGES ON $db.* TO '$user'@'%';"
    } > "$HOME/init.sql"
    $cmd < "$HOME/init.sql"
    rm "$HOME/init.sql"
done
