-- =====================================================
-- MISE À JOUR : AJOUT DU NIVEAU ZD (ZONE DE DÉNOMBREMENT)
-- =====================================================

USE menage;

-- =====================================================
-- 3b. TABLE STATS PAR ZD
-- =====================================================

DROP TABLE IF EXISTS stats_par_zd;

CREATE TABLE stats_par_zd (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code_region VARCHAR(10),
    code_departement VARCHAR(10),
    code_commune VARCHAR(10),
    mo_zd VARCHAR(20), -- Identifiant de la ZD
    
    -- Stats ménages
    total_menages INT DEFAULT 0,
    total_population BIGINT DEFAULT 0,
    nb_menages_plus_10 INT DEFAULT 0,
    nb_menages_solo INT DEFAULT 0,
    population_rurale INT DEFAULT 0,
    menages_enumeres INT DEFAULT 0,
    menages_denombres INT DEFAULT 0,
    population_carto INT DEFAULT 0,
    population_collectee INT DEFAULT 0,
    
    -- Stats population
    hommes INT DEFAULT 0,
    femmes INT DEFAULT 0,
    nb_enfants_moins_5 INT DEFAULT 0,
    nb_residents_absents INT DEFAULT 0,
    nb_visiteurs INT DEFAULT 0,
    nb_naissances_vivantes INT DEFAULT 0,
    nb_femmes_15_49 INT DEFAULT 0,
    
    -- Stats agricoles et émigration
    menages_agricoles INT DEFAULT 0,
    total_emigres INT DEFAULT 0,
    menages_avec_emigres INT DEFAULT 0,
    
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Index composite pour recherche rapide par ZD ou par Commune+ZD
    INDEX idx_zd (mo_zd),
    INDEX idx_geo_full (code_commune, mo_zd)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- 6b. TABLE PYRAMIDE DES ÂGES PRÉ-CALCULÉE PAR ZD
-- =====================================================

DROP TABLE IF EXISTS pyramide_ages_zd;

CREATE TABLE pyramide_ages_zd (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mo_zd VARCHAR(20),
    age_range VARCHAR(10),
    hommes INT DEFAULT 0,
    femmes INT DEFAULT 0,
    
    date_maj TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_zd_age (mo_zd, age_range)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT '✅ Tables ZD créées avec succès!' AS status;