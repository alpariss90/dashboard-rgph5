// Dans votre fichier de routes (ex: routes/api.js)
const express = require('express');
const router = express.Router();
const fs = require('fs').promises;
const path = require('path');

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

module.exports = router;