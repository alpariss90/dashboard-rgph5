// Dans votre fichier de routes (ex: routes/api.js)
const express = require('express');
const router = express.Router();
const fs = require('fs').promises;
const path = require('path');
const { QueryTypes } = require('sequelize');
const menageDB = require('../config/menageDB');
const { cacheHelper } = require('../config/redis');

// API pour récupérer les régions
router.get('/regions', async (req, res) => {
    try {
        const filePath = path.join(__dirname, '../geoJSON/RegionNiger.geojson');
        console.log('Lecture du fichier:', filePath);
        
        const data = await fs.readFile(filePath, 'utf8');
        res.json(JSON.parse(data));
    } catch (error) {
        console.error('Erreur API regions:', error);
        res.status(500).json({ 
            error: 'Erreur de chargement',
            details: error.message 
        });
    }
});

// API pour récupérer les départements
router.get('/departements', async (req, res) => {
    try {
        const filePath = path.join(__dirname, '../geoJSON/DepartementNiger.geojson');
        console.log('Lecture du fichier:', filePath);
        
        const data = await fs.readFile(filePath, 'utf8');
        res.json(JSON.parse(data));
    } catch (error) {
        console.error('Erreur API départements:', error);
        res.status(500).json({ 
            error: 'Erreur de chargement',
            details: error.message 
        });
    }
});

// 1. Pour les statistiques par région
router.get('/stats/regions', async (req, res) => {
    try {
        const sql = `
            SELECT
                tm.code_region AS regionCode,
                tm.region AS regionName,
                COALESCE(zr.populationCarto, 0) AS populationCarto,
                SUM(tm.xm40) AS populationCollectee
            FROM tmenage tm
            LEFT JOIN (
                SELECT
                    SUBSTRING(zd_zd, 1, 1) AS code_region,
                    SUM(CAST(zd_pop AS UNSIGNED)) AS populationCarto
                FROM zd
                GROUP BY SUBSTRING(zd_zd, 1, 1)
            ) zr ON zr.code_region = tm.code_region
            GROUP BY tm.code_region, tm.region, zr.populationCarto
            ORDER BY tm.region ASC
        `;

        const rows = await menageDB.query(sql, { type: QueryTypes.SELECT });

        const codeToUpperCaseName = {
            'NER001': 'AGADEZ',
            'NER002': 'DIFFA',
            'NER003': 'DOSSO',
            'NER004': 'MARADI',
            'NER005': 'TAHOUA',
            'NER006': 'TILLABERI',
            'NER007': 'ZINDER',
            'NER008': 'NIAMEY'
        };

        const result = rows.map(r => {
            const upperCaseName =
                codeToUpperCaseName[r.regionCode] ||
                (r.regionName ? r.regionName.toUpperCase().trim() : '');

            return {
                regionName: upperCaseName,
                regionDisplayName: r.regionName,
                regionCode: r.regionCode,
                populationCarto: Number(r.populationCarto || 0),
                populationCollectee: Number(r.populationCollectee || 0)
            };
        });

        console.log('📊 Statistiques régions préparées:');
        result.forEach(r => {
            console.log(`Code: ${r.regionCode} | GeoJSON: ${r.regionName} | Original: ${r.regionDisplayName}`);
            console.log(`Carto: ${r.populationCarto} | Collectée: ${r.populationCollectee}`);
        });

        res.json(result);

    } catch (error) {
        console.error('❌ Erreur API régions:', error);
        res.status(500).json({
            error: 'Erreur serveur',
            details: error.message
        });
    }
});

// 2. Pour les statistiques par département (à créer)
router.get('/stats/departements', async (req, res) => {
    try {
        const sql = `
            SELECT
                tm.code_departement AS departementCode,
                tm.departement AS departementName,
                tm.code_region AS regionCode,
                tm.region AS regionName,
                COALESCE(zdg.populationCarto, 0) AS populationCarto,
                SUM(tm.xm40) AS populationCollectee
            FROM tmenage tm
            LEFT JOIN (
                SELECT
                    SUBSTRING(TRIM(zd_zd), 1, 3) AS code_departement,
                    SUM(CAST(TRIM(zd_pop) AS UNSIGNED)) AS populationCarto
                FROM zd
                GROUP BY SUBSTRING(TRIM(zd_zd), 1, 3)
            ) zdg ON zdg.code_departement = tm.code_departement
            GROUP BY
                tm.code_departement,
                tm.departement,
                tm.code_region,
                tm.region,
                zdg.populationCarto
            ORDER BY tm.region ASC, tm.departement ASC
        `;

        const rows = await menageDB.query(sql, { type: QueryTypes.SELECT });

        const result = rows.map(r => ({
            departementCode: r.departementCode,
            departement: r.departementName,
            region: r.region,
            populationCarto: Number(r.populationCarto || 0),
            populationCollectee: Number(r.populationCollectee || 0)
        }));

        res.json(result);
    } catch (error) {
        console.error('❌ Erreur API départements:', error);
        res.status(500).json({
            error: 'Erreur serveur',
            details: error.message
        });
    }
});
module.exports = router;