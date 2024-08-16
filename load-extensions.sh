#!/bin/sh
set -e

echo "shared_preload_libraries = 'pg_stat_statements, pg_qualstats'" >> $PGDATA/postgresql.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  create extension if not exists "hypopg";
  create extension if not exists "pg_stat_statements";
  create extension if not exists "pg_qualstats";
  select * FROM pg_extension;
EOSQL

