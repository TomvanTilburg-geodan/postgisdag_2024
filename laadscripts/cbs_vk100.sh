#!/usr/bin/env bash

mkdir -p ../data/cbs

URL="https://download.cbs.nl/vierkant/100/2024-cbs_vk100_2021_vol.zip"
echo "Downloading $URL"
curl -s -L -o ../data/cbs/$(basename $URL) $URL
unzip -o -d ../data/cbs/ ../data/cbs/$(basename $URL)
rm -f ../data/cbs/*.zip

psql -d hexagons -q -c "CREATE EXTENSION IF NOT EXISTS postgis; CREATE SCHEMA IF NOT EXISTS cbs; DROP TABLE IF EXISTS cbs.cbs_vk100;"

ogr2ogr PG:"dbname=hexagons" \
    ../data/cbs/cbs_vk100_2021_vol.gpkg cbs_vk100_2021 \
    -overwrite \
    -nln cbs.cbs_vk100 \
    -lco GEOMETRY_NAME=geom \
    -t_srs epsg:28992

