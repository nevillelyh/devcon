#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

[[ -f "$HOME/init-complete" ]] && exit 0

/init/wait-for-it.sh postgres.devcon.io:5432 -s -t 0 -- echo "PostgreSQL is up"

export PGPASSWORD=postgrespass
cmd="psql --host=postgres.devcon.io --user=postgres"
for db in "${POSTGRES_PRIVATE_DATABASES[@]}"; do
    user="$db"
    pass="${db}pass"

    echo "Creating PostgreSQL database $db: user=$user password=$pass"
    {
        echo "CREATE ROLE $user LOGIN PASSWORD '$pass';"
        echo "CREATE DATABASE $db OWNER $user;"
    } > "$HOME/init.sql"
    $cmd --file="$HOME/init.sql"
    rm "$HOME/init.sql"
done

user="pgsql"
pass="pgsqlpass"
$cmd --command="CREATE ROLE $user LOGIN PASSWORD '$pass'"
for db in "${POSTGRES_PUBLIC_DATABASES[@]}"; do
    echo "Creating PostgreSQL database $db: user=$user password=$pass"
    $cmd --command="CREATE DATABASE $db OWNER $user;"
done

touch "$HOME/init-complete"
