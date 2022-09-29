#!/bin/bash

set -euo pipefail

# shellcheck disable=SC1091
source /conf.sh

/init/wait-for-it.sh postgres.devcon.io:5432 -s -t 0 -- echo "PostgreSQL is up"
export PGPASSWORD=postgrespass
cmd="psql --host=postgres.devcon.io --user=postgres"

for db in "${POSTGRES_PRIVATE_DATABASES[@]}"; do
    user="$db"
    pass="${db}pass"

    echo "Creating PostgreSQL database $db: user=$user password=$pass"
    {
        echo "DROP ROLE IF EXISTS $user;"
        echo "CREATE ROLE $user LOGIN PASSWORD '$pass';"
        echo "SELECT 'CREATE DATABASE $db OWNER $user' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$db')\gexec"
    } > "$HOME/init.sql"
    $cmd --file="$HOME/init.sql"
    rm "$HOME/init.sql"
done

user="pgsql"
pass="pgsqlpass"
$cmd --command="DROP ROLE IF EXISTS $user"
$cmd --command="CREATE ROLE $user LOGIN PASSWORD '$pass'"
for db in "${POSTGRES_PUBLIC_DATABASES[@]}"; do
    echo "Creating PostgreSQL database $db: user=$user password=$pass"
    {
        echo "SELECT 'CREATE DATABASE $db OWNER $user' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$db')\gexec"
    } > "$HOME/init.sql"
    $cmd --file="$HOME/init.sql"
    rm "$HOME/init.sql"
done
