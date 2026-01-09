module.exports = (req, res, next) => {
    // 1. Récupération sécurisée du rôle depuis la session
    // Si req.session.user n'existe pas, on considère l'utilisateur comme 'VISITOR'
    const user = req.session.user || {}; 
    const userRole = user.role || 'VISITOR';

    // 2. Définition des permissions
    res.locals.mapAccess = {
        // Carte REGION : Visible pour Global et Régional
        showRegionMap: ['ROLE_GLOBAL', 'ROLE_REGIONAL'].includes(userRole),
        
        // Carte DEPARTEMENT : Visible pour Global, Régional et Départemental
        showDeptMap: ['ROLE_GLOBAL', 'ROLE_REGIONAL', 'ROLE_DEPARTEMENTAL'].includes(userRole),
        isCommunal: userRole === 'ROLE_COMMUNAL'
    };

    res.locals.chartAccess = {
        showChartGlobal: ['ROLE_GLOBAL'].includes(userRole),
    };

    // Log pour le débuggage (à commenter en production)
    console.log(`[MapAuth] User: ${user.email || 'Anonyme'} | Role: ${userRole} | Maps: Reg=${res.locals.mapAccess.showRegionMap}, Dept=${res.locals.mapAccess.showDeptMap}`);

    next();
};