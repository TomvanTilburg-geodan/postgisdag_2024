#!/usr/bin/env bash

export PGPASSWORD=guest
export PGUSER=guest
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=hexagons

psql -d hexagons -c "create schema if not exists rws;"

ogr2ogr \
  -f "PostgreSQL" PG:"" \
  -nln bevaarbaarheid \
  -lco SCHEMA=rws \
  bevaarbaarheid.geojson
