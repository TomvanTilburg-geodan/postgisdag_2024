#!/usr/bin/env bash

#bestand downloaden via https://lgn.nl/bestanden

srcdata=../data/LGN2023/LGN2023.tif

gdal_translate $srcdata ../data/LGN2023/LGN2023_COG.tif \
	-of COG \
        -co COMPRESS=DEFLATE \
        -co NUM_THREADS=ALL_CPUS \
        --config GDAL_CACHEMAX 512

raster2pgsql -s 28992 -t auto -d -F -I -Y ../data/LGN2023/LGN2023_COG.tif novex_base.lgn2023 > ../data/lgn_2023.sql
