const fs = require('fs');
const path = require('path');

// Chemins vers vos fichiers (adaptez selon votre structure)
const REGIONS_FILE = path.join(__dirname, '../public/data/RegionNiger.geojson');
const DEPARTEMENTS_FILE = path.join(__dirname, '../public/data/DepartementNiger.geojson');

/**
 * Helper pour charger le GeoJSON
 */
const loadGeoJSON = (filePath) => {
    try {
        const rawData = fs.readFileSync(filePath, 'utf8');
        return JSON.parse(rawData);
    } catch (error) {
        console.error(`Erreur lecture ${filePath}:`, error);
        return null;
    }
};

/**
 * API : Récupérer les régions filtrées
 */
exports.getRegions = (req, res) => {
    const geoJson = loadGeoJSON(REGIONS_FILE);
    if (!geoJson) return res.status(500).json({ error: "Données introuvables" });

    const user = req.session.user || {};
    const role = user.role;
    // On s'assure de comparer en MAJUSCULES car vos GeoJSON sont en majuscules (ex: "DOSSO")
    const userLocation = (user.location_name || '').toUpperCase(); 

    let filteredFeatures = [];

    switch (role) {
        case 'ROLE_GLOBAL':
            // Voit tout le pays
            filteredFeatures = geoJson.features;
            break;

        case 'ROLE_REGIONAL':
            // Ne voit que sa propre région (basé sur NOMREG)
            filteredFeatures = geoJson.features.filter(feature => 
                feature.properties.NOMREG === userLocation
            );
            break;

        case 'ROLE_DEPARTEMENTAL':
            // Option A : Ne voit PAS la carte régionale (géré par le middleware qui masque la div)
            // Option B : Voit sa région parente (si vous le souhaitez)
            // Pour l'instant, on renvoie vide ou la région parente selon votre choix.
            // Si on suit votre logique "ne verra que son unique departement", cette API région n'est peut-être même pas appelée.
            filteredFeatures = []; 
            break;

        default:
            filteredFeatures = [];
    }

    // On renvoie un nouvel objet GeoJSON valide avec seulement les features filtrées
    res.json({
        type: "FeatureCollection",
        features: filteredFeatures
    });
};

/**
 * API : Récupérer les départements filtrés
 */
exports.getDepartements = (req, res) => {
    const geoJson = loadGeoJSON(DEPARTEMENTS_FILE);
    if (!geoJson) return res.status(500).json({ error: "Données introuvables" });

    const user = req.session.user || {};
    const role = user.role;
    const userLocation = (user.location_name || '').toUpperCase();
    const userRegion = (user.region_name || '').toUpperCase(); // Si un user départemental a aussi le nom de sa région stocké

    let filteredFeatures = [];

    switch (role) {
        case 'ROLE_GLOBAL':
            // Voit tous les départements du pays
            filteredFeatures = geoJson.features;
            break;

        case 'ROLE_REGIONAL':
            // Voit tous les départements DANS sa région
            // On utilise la propriété 'adm_01' qui contient le nom de la région dans le fichier départements
            filteredFeatures = geoJson.features.filter(feature => 
                feature.properties.adm_01.toUpperCase() === userLocation
            );
            break;

        case 'ROLE_DEPARTEMENTAL':
            // Ne voit QUE son département spécifique
            filteredFeatures = geoJson.features.filter(feature => 
                feature.properties.NOMDEP === userLocation
            );
            break;

        default:
            filteredFeatures = [];
    }

    res.json({
        type: "FeatureCollection",
        features: filteredFeatures
    });
};