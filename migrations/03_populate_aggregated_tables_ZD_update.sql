-- =====================================================
-- PEUPLEMENT DES TABLES ZD
-- =====================================================

USE menage;
SET SESSION sql_mode = 'TRADITIONAL';

-- =====================================================
-- 4b. STATS PAR ZD
-- =====================================================

SELECT '📊 Calcul des statistiques par ZD (Cela peut prendre du temps)...' AS status;

TRUNCATE TABLE stats_par_zd;

INSERT INTO stats_par_zd (
    code_region, code_departement, code_commune, mo_zd,
    total_menages, total_population, nb_menages_plus_10, nb_menages_solo,
    population_rurale, menages_enumeres, menages_denombres,
    population_carto, population_collectee,
    hommes, femmes, nb_enfants_moins_5, nb_residents_absents, nb_visiteurs,
    nb_naissances_vivantes, nb_femmes_15_49,
    menages_agricoles, total_emigres, menages_avec_emigres
)
SELECT 
    m.code_region,
    m.code_departement,
    m.code_commune,
    m.mo_zd,
    COUNT(*) AS total_menages,
    COALESCE(SUM(m.nb_residents), 0) AS total_population,
    SUM(CASE WHEN m.xm40 > 10 THEN 1 ELSE 0 END) AS nb_menages_plus_10,
    SUM(CASE WHEN m.xm40 = 1 THEN 1 ELSE 0 END) AS nb_menages_solo,
    SUM(CASE WHEN m.xm01 = 2 THEN 1 ELSE 0 END) AS population_rurale,
    SUM(CASE WHEN m.xm30 > 0 THEN 1 ELSE 0 END) AS menages_enumeres,
    SUM(CASE WHEN m.xm13 = 1 THEN 1 ELSE 0 END) AS menages_denombres,
    COALESCE(SUM(m.xm20), 0) AS population_carto,
    COALESCE(SUM(m.xm40), 0) AS population_collectee,
    
    -- Sous-requêtes corrélées (optimisées par index)
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c03 = 1) AS hommes,
     
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c03 = 2) AS femmes,
     
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c06 < 5) AS nb_enfants_moins_5,
     
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c04 = 2) AS nb_residents_absents,
     
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c04 = 3) AS nb_visiteurs,
     
    (SELECT COALESCE(SUM(c.c24_t), 0) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c24_t > 0) AS nb_naissances_vivantes,
     
    (SELECT COUNT(*) FROM tcaracteristique c 
     INNER JOIN tmenage m2 ON m2.`level-1-id` = c.`level-1-id` 
     WHERE m2.mo_zd = m.mo_zd AND c.c03 = 2 AND c.c06 BETWEEN 15 AND 49) AS nb_femmes_15_49,
     
    (SELECT COUNT(DISTINCT a.`level-1-id`) FROM tagriculture a
     INNER JOIN tmenage m2 ON m2.`level-1-id` = a.`level-1-id`
     WHERE m2.mo_zd = m.mo_zd) AS menages_agricoles,
     
    (SELECT COALESCE(SUM(e.em02), 0) FROM temigration e
     INNER JOIN tmenage m2 ON m2.`level-1-id` = e.`level-1-id`
     WHERE m2.mo_zd = m.mo_zd) AS total_emigres,
     
    (SELECT COUNT(DISTINCT e.`level-1-id`) FROM temigration e
     INNER JOIN tmenage m2 ON m2.`level-1-id` = e.`level-1-id`
     WHERE m2.mo_zd = m.mo_zd AND e.em02 > 0) AS menages_avec_emigres
     
FROM tmenage m
GROUP BY m.code_region, m.code_departement, m.code_commune, m.mo_zd;

SELECT '✅ Stats par ZD calculées' AS status;

-- =====================================================
-- 8b. PYRAMIDE DES ÂGES PAR ZD
-- =====================================================

SELECT '📊 Calcul pyramides des âges par ZD...' AS status;

TRUNCATE TABLE pyramide_ages_zd;

INSERT INTO pyramide_ages_zd (mo_zd, age_range, hommes, femmes)
SELECT 
    m.mo_zd,
    age_range,
    SUM(CASE WHEN c.c03 = 1 THEN 1 ELSE 0 END) AS hommes,
    SUM(CASE WHEN c.c03 = 2 THEN 1 ELSE 0 END) AS femmes
FROM (
    SELECT 
        c03,
        `level-1-id`,
        CASE
            WHEN c06 BETWEEN 0 AND 4 THEN '0-4'
            WHEN c06 BETWEEN 5 AND 9 THEN '5-9'
            WHEN c06 BETWEEN 10 AND 14 THEN '10-14'
            WHEN c06 BETWEEN 15 AND 19 THEN '15-19'
            WHEN c06 BETWEEN 20 AND 24 THEN '20-24'
            WHEN c06 BETWEEN 25 AND 29 THEN '25-29'
            WHEN c06 BETWEEN 30 AND 34 THEN '30-34'
            WHEN c06 BETWEEN 35 AND 39 THEN '35-39'
            WHEN c06 BETWEEN 40 AND 44 THEN '40-44'
            WHEN c06 BETWEEN 45 AND 49 THEN '45-49'
            WHEN c06 BETWEEN 50 AND 54 THEN '50-54'
            WHEN c06 BETWEEN 55 AND 59 THEN '55-59'
            WHEN c06 BETWEEN 60 AND 64 THEN '60-64'
            WHEN c06 BETWEEN 65 AND 69 THEN '65-69'
            WHEN c06 BETWEEN 70 AND 74 THEN '70-74'
            WHEN c06 BETWEEN 75 AND 79 THEN '75-79'
            ELSE '80+'
        END AS age_range
    FROM tcaracteristique
) AS c
INNER JOIN tmenage m ON m.`level-1-id` = c.`level-1-id`
GROUP BY m.mo_zd, age_range;

SELECT '✅ Pyramides par ZD calculées' AS status;