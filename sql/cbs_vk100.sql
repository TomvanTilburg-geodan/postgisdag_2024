DROP TABLE IF EXISTS h3.cbs_vk100 CASCADE;

CREATE TABLE h3.cbs_vk100 (
    h3 h3index,
    num_cbs_cells int,
    aantal_inwoners int,
    aantal_mannen int,
    aantal_vrouwen int,
    aantal_inwoners_0_tot_15_jaar int,
    aantal_inwoners_15_tot_25_jaar int,
    aantal_inwoners_25_tot_45_jaar int,
    aantal_inwoners_45_tot_65_jaar int,
    aantal_inwoners_65_jaar_en_ouder int,
    gemiddelde_huishoudensgrootte float,
    aantal_woningen int,
    gemiddelde_woz_waarde_woning int,
    aantal_personen_met_uitkering_onder_aowlft int,
    dichtstbijzijnde_grote_supermarkt_afstand_in_km float,
    grote_supermarkt_aantal_binnen_1_km int,
    grote_supermarkt_aantal_binnen_3_km int,
    grote_supermarkt_aantal_binnen_5_km int,
    dichtstbijzijnde_winkels_ov_dagel_levensm_afst_in_km float,
    winkels_ov_dagel_levensm_aantal_binnen_1_km int,
    winkels_ov_dagel_levensm_aantal_binnen_3_km int,
    winkels_ov_dagel_levensm_aantal_binnen_5_km int,
    dichtstbijzijnde_buitenschoolse_opvang_afstand_in_km float,
    buitenschoolse_opvang_aantal_binnen_1_km int,
    buitenschoolse_opvang_aantal_binnen_3_km int,
    buitenschoolse_opvang_aantal_binnen_5_km int,
    dichtstbijzijnde_kinderdagverblijf_afstand_in_km float,
    kinderdagverblijf_aantal_binnen_1_km int,
    kinderdagverblijf_aantal_binnen_3_km int,
    kinderdagverblijf_aantal_binnen_5_km int,
    dichtstbijzijnde_oprit_hoofdverkeersweg_afstand_in_km float,
    dichtstbijzijnde_treinstation_afstand_in_km float,
    dichtstbijzijnde_zwembad_afstand_in_km float,
    dichtstbijzijnde_basisonderwijs_afstand_in_km float,
    basisonderwijs_aantal_binnen_1_km int,
    basisonderwijs_aantal_binnen_3_km int,
    basisonderwijs_aantal_binnen_5_km int,
    dichtstbijzijnde_voortgezet_onderwijs_afstand_in_km float,
    voortgezet_onderwijs_aantal_binnen_3_km int,
    voortgezet_onderwijs_aantal_binnen_5_km int,
    voortgezet_onderwijs_aantal_binnen_10_km int,
    dichtstbijzijnde_huisartsenpraktijk_afstand_in_km float,
    huisartsenpraktijk_aantal_binnen_1_km int,
    huisartsenpraktijk_aantal_binnen_3_km int,
    huisartsenpraktijk_aantal_binnen_5_km int,
    dichtstbijzijnde_ziekenh_excl_buitenpoli_afst_in_km float,
    ziekenhuis_excl_buitenpoli_aantal_binnen_5_km int,
    ziekenhuis_excl_buitenpoli_aantal_binnen_10_km int,
    ziekenhuis_excl_buitenpoli_aantal_binnen_20_km int,
    dichtstbijzijnde_apotheek_afstand_in_km float,
    reistijd int
) USING columnar;

DELETE FROM h3.cbs_vk100;

CREATE
OR REPLACE FUNCTION cbs_null(value integer) RETURNS integer AS
$$
SELECT
    CASE
        WHEN value < -999 THEN NULL
        ELSE value
    END AS ret_value;

$$
language SQL;

CREATE
OR REPLACE FUNCTION cbs_null(value float) RETURNS float AS
$$
SELECT
    CASE
        WHEN value < -999 THEN NULL
        ELSE value
    END AS ret_value;

$$
language SQL;

INSERT INTO
    h3.cbs_vk100
    --TODO: avgs should be weighed by population
SELECT
    h3_lat_lng_to_cell(ST_Transform(ST_Centroid(a.geom), 4326), 9) AS h3,
    count(a.geom) AS num_cbs_cells,
    sum(aantal_inwoners) aantal_inwoners,
    sum(cbs_null(aantal_mannen)) aantal_mannen,
    sum(cbs_null(aantal_vrouwen)) aantal_vrouwen,
    sum(cbs_null(aantal_inwoners_0_tot_15_jaar)) aantal_inwoners_0_tot_15_jaar,
    sum(cbs_null(aantal_inwoners_15_tot_25_jaar)) aantal_inwoners_15_tot_25_jaar,
    sum(cbs_null(aantal_inwoners_25_tot_45_jaar)) aantal_inwoners_25_tot_45_jaar,
    sum(cbs_null(aantal_inwoners_45_tot_65_jaar)) aantal_inwoners_45_tot_65_jaar,
    sum(cbs_null(aantal_inwoners_65_jaar_en_ouder)) aantal_inwoners_65_jaar_en_ouder,
    avg(cbs_null(gemiddelde_huishoudensgrootte)) gemiddelde_huishoudensgrootte,
    sum(aantal_woningen) aantal_woningen,
    avg(cbs_null(gemiddelde_woz_waarde_woning)) gemiddelde_woz_waarde_woning,
    sum(aantal_personen_met_uitkering_onder_aowlft) aantal_personen_met_uitkering_onder_aowlft,
    avg(
        cbs_null(dichtstbijzijnde_grote_supermarkt_afstand_in_km)
    ) dichtstbijzijnde_grote_supermarkt_afstand_in_km,
    avg(grote_supermarkt_aantal_binnen_1_km) grote_supermarkt_aantal_binnen_1_km,
    avg(grote_supermarkt_aantal_binnen_3_km) grote_supermarkt_aantal_binnen_3_km,
    avg(grote_supermarkt_aantal_binnen_5_km) grote_supermarkt_aantal_binnen_5_km,
    avg(
        cbs_null(
            dichtstbijzijnde_winkels_ov_dagel_levensm_afst_in_km
        )
    ) dichtstbijzijnde_winkels_ov_dagel_levensm_afst_in_km,
    avg(winkels_ov_dagel_levensm_aantal_binnen_1_km) winkels_ov_dagel_levensm_aantal_binnen_1_km,
    avg(winkels_ov_dagel_levensm_aantal_binnen_3_km) winkels_ov_dagel_levensm_aantal_binnen_3_km,
    avg(winkels_ov_dagel_levensm_aantal_binnen_5_km) winkels_ov_dagel_levensm_aantal_binnen_5_km,
    avg(
        cbs_null(
            dichtstbijzijnde_buitenschoolse_opvang_afstand_in_km
        )
    ) dichtstbijzijnde_buitenschoolse_opvang_afstand_in_km,
    avg(buitenschoolse_opvang_aantal_binnen_1_km) buitenschoolse_opvang_aantal_binnen_1_km,
    avg(buitenschoolse_opvang_aantal_binnen_3_km) buitenschoolse_opvang_aantal_binnen_3_km,
    avg(buitenschoolse_opvang_aantal_binnen_5_km) buitenschoolse_opvang_aantal_binnen_5_km,
    avg(
        cbs_null(dichtstbijzijnde_kinderdagverblijf_afstand_in_km)
    ) dichtstbijzijnde_kinderdagverblijf_afstand_in_km,
    avg(kinderdagverblijf_aantal_binnen_1_km) kinderdagverblijf_aantal_binnen_1_km,
    avg(kinderdagverblijf_aantal_binnen_3_km) kinderdagverblijf_aantal_binnen_3_km,
    avg(kinderdagverblijf_aantal_binnen_5_km) kinderdagverblijf_aantal_binnen_5_km,
    avg(
        cbs_null(
            dichtstbijzijnde_oprit_hoofdverkeersweg_afstand_in_km
        )
    ) dichtstbijzijnde_oprit_hoofdverkeersweg_afstand_in_km,
    avg(
        cbs_null(dichtstbijzijnde_treinstation_afstand_in_km)
    ) dichtstbijzijnde_treinstation_afstand_in_km,
    avg(cbs_null(dichtstbijzijnde_zwembad_afstand_in_km)) dichtstbijzijnde_zwembad_afstand_in_km,
    avg(
        cbs_null(dichtstbijzijnde_basisonderwijs_afstand_in_km)
    ) dichtstbijzijnde_basisonderwijs_afstand_in_km,
    avg(basisonderwijs_aantal_binnen_1_km) basisonderwijs_aantal_binnen_1_km,
    avg(basisonderwijs_aantal_binnen_3_km) basisonderwijs_aantal_binnen_3_km,
    avg(basisonderwijs_aantal_binnen_5_km) basisonderwijs_aantal_binnen_5_km,
    avg(
        cbs_null(
            dichtstbijzijnde_voortgezet_onderwijs_afstand_in_km
        )
    ) dichtstbijzijnde_voortgezet_onderwijs_afstand_in_km,
    avg(voortgezet_onderwijs_aantal_binnen_3_km) voortgezet_onderwijs_aantal_binnen_3_km,
    avg(voortgezet_onderwijs_aantal_binnen_5_km) voortgezet_onderwijs_aantal_binnen_5_km,
    avg(voortgezet_onderwijs_aantal_binnen_10_km) voortgezet_onderwijs_aantal_binnen_10_km,
    avg(
        cbs_null(
            dichtstbijzijnde_huisartsenpraktijk_afstand_in_km
        )
    ) dichtstbijzijnde_huisartsenpraktijk_afstand_in_km,
    avg(huisartsenpraktijk_aantal_binnen_1_km) huisartsenpraktijk_aantal_binnen_1_km,
    avg(huisartsenpraktijk_aantal_binnen_3_km) huisartsenpraktijk_aantal_binnen_3_km,
    avg(huisartsenpraktijk_aantal_binnen_5_km) huisartsenpraktijk_aantal_binnen_5_km,
    avg(
        cbs_null(
            dichtstbijzijnde_ziekenh_excl_buitenpoli_afst_in_km
        )
    ) dichtstbijzijnde_ziekenh_excl_buitenpoli_afst_in_km,
    avg(ziekenhuis_excl_buitenpoli_aantal_binnen_5_km) ziekenhuis_excl_buitenpoli_aantal_binnen_5_km,
    avg(ziekenhuis_excl_buitenpoli_aantal_binnen_10_km) ziekenhuis_excl_buitenpoli_aantal_binnen_10_km,
    avg(ziekenhuis_excl_buitenpoli_aantal_binnen_20_km) ziekenhuis_excl_buitenpoli_aantal_binnen_20_km,
    avg(
        cbs_null(dichtstbijzijnde_apotheek_afstand_in_km)
    ) dichtstbijzijnde_apotheek_afstand_in_km
FROM
    cbs.cbs_vk100 a
GROUP BY
    h3_lat_lng_to_cell(ST_Transform(ST_Centroid(a.geom), 4326), 9);

DROP MATERIALIZED VIEW IF EXISTS h3.cbs_vk100_vw;

CREATE MATERIALIZED VIEW h3.cbs_vk100_vw AS
SELECT
    *,
    h3_cell_to_boundary_geometry(h3) AS geom
FROM
    h3.cbs_vk100;

CREATE INDEX ON h3.cbs_vk100_vw USING GIST(geom);
