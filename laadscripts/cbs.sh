#!/usr/bin/env bash

export PGUSER=postgres
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=hexagons
export PGPASSWORD=postgres

psql -d hexagons -c "CREATE SCHEMA cbs;"

wget https://geodata.cbs.nl/files/Wijkenbuurtkaart/WijkBuurtkaart_2024_v1.zip
ogrinfo -so /vsizip/WijkBuurtkaart_2024_v1.zip
ogr2ogr \
  -f "PostgreSQL" PG:"dbname=hexagons" \
  -lco SCHEMA=cbs \
  /vsizip/WijkBuurtkaart_2024_v1.zip

rm WijkBuurtkaart_2024_v1.zip
