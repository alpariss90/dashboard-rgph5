#!/bin/bash
# Script pour appliquer les migrations MySQL dans le bon ordre
# Usage: ./apply_migrations.sh
# Placez ce script dans dashboard-bcr-genspark_ai_developer/

# Fonction pour afficher un message en couleur
print_color() {
    local color=$1
    local message=$2
    case $color in
        red)    echo -e "\033[31m$message\033[0m" ;;
        green)  echo -e "\033[32m$message\033[0m" ;;
        yellow) echo -e "\033[33m$message\033[0m" ;;
        blue)   echo -e "\033[34m$message\033[0m" ;;
        *)      echo -e "$message" ;;
    esac
}

# Afficher le répertoire courant
CURRENT_DIR=$(pwd)
print_color blue "📂 Répertoire courant: $CURRENT_DIR"

# Charger les variables d'environnement
if [ -f ".env" ]; then
    print_color green "✅ Fichier .env trouvé"
    export $(grep -v '^#' .env | xargs)
else
    print_color yellow "⚠️  Fichier .env non trouvé dans $CURRENT_DIR"
    print_color yellow "   Utilisation des valeurs par défaut"
fi

# Variables de connexion avec valeurs par défaut
DB_HOST="${MENAGE_DB_HOST:-localhost}"
DB_PORT="${MENAGE_DB_PORT:-3306}"
DB_NAME="${MENAGE_DB_NAME:-menageDBTEST}"
DB_USER="${MENAGE_DB_USER:-root}"
DB_PASSWORD="${MENAGE_DB_PASSWORD}"

# Répertoire des migrations (chemin relatif)
MIGRATIONS_DIR="migrations"

clear
echo "=========================================="
print_color blue "🔧 APPLICATION DES MIGRATIONS MySQL"
echo "=========================================="
echo "Répertoire: $CURRENT_DIR"
echo "Dossier migrations: $MIGRATIONS_DIR"
echo "Base de données: $DB_NAME"
echo "Hôte: $DB_HOST:$DB_PORT"
echo "Utilisateur: $DB_USER"
echo "=========================================="
echo ""

# Vérifier si le dossier migrations existe
if [ ! -d "$MIGRATIONS_DIR" ]; then
    print_color red "❌ Le dossier '$MIGRATIONS_DIR' n'existe pas dans $CURRENT_DIR"
    echo ""
    echo "Structure attendue:"
    echo "dashboard-bcr-genspark_ai_developer/"
    echo "├── apply_migrations.sh    (ce script)"
    echo "└── migrations/"
    echo "    ├── 00_create_table_user.sql"
    echo "    ├── 01_populate_region_dept_commne_tables.sql"
    echo "    └── ..."
    echo ""
    read -p "Appuyez sur Entrée pour fermer..." -n 1 -r
    exit 1
fi

# Afficher les fichiers disponibles
print_color blue "📁 FICHIERS DISPONIBLES DANS $MIGRATIONS_DIR/:"
ls -la "$MIGRATIONS_DIR/" 2>/dev/null | grep -E '\.sql$' || print_color red "   (aucun fichier .sql trouvé)"

echo ""
# Demander confirmation
read -p "Voulez-vous continuer? (o/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Oo]$ ]]; then
    print_color yellow "❌ Opération annulée"
    read -p "Appuyez sur Entrée pour fermer..." -n 1 -r
    exit 0
fi

# Construire la commande MySQL
if [ -n "$DB_PASSWORD" ]; then
    MYSQL_CMD="mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASSWORD --show-warnings"
else
    MYSQL_CMD="mysql -h$DB_HOST -P$DB_PORT -u$DB_USER --show-warnings"
fi

# Tester la connexion MySQL
print_color blue "🔗 Test de connexion MySQL..."
if echo "SELECT 1;" | $MYSQL_CMD 2>/dev/null >/dev/null; then
    mysql_version=$(echo "SELECT VERSION();" | $MYSQL_CMD 2>/dev/null | tail -1)
    print_color green "✅ Connecté à MySQL $mysql_version"
else
    print_color red "❌ Échec de connexion à MySQL"
    echo "Commande: $MYSQL_CMD"
    echo "Vérifiez:"
    echo "1. MySQL est-il démarré? (sudo service mysql status)"
    echo "2. Mot de passe correct?"
    read -p "Appuyez sur Entrée pour fermer..." -n 1 -r
    exit 1
fi

# Fonction pour créer la base de données
create_database() {
    print_color blue "🔍 Vérification base '$DB_NAME'..."
    
    if echo "SHOW DATABASES LIKE '$DB_NAME'" | $MYSQL_CMD 2>/dev/null | grep -q "$DB_NAME"; then
        print_color green "✅ Base '$DB_NAME' existe déjà"
        return 0
    else
        print_color yellow "📝 Création de '$DB_NAME'..."
        if echo "CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | $MYSQL_CMD 2>/dev/null; then
            print_color green "✅ Base créée"
            return 0
        else
            print_color red "❌ Échec création"
            return 1
        fi
    fi
}

# Fonction simple pour exécuter un script SQL
run_sql_file() {
    local file="$1"
    local description="$2"
    
    print_color blue "📋 $description..."
    echo "   Fichier: $file"
    
    if [ ! -f "$file" ]; then
        print_color red "   ❌ Fichier non trouvé: $file"
        return 1
    fi
    
    # Vérifier la taille du fichier
    file_size=$(wc -l < "$file" 2>/dev/null || echo "0")
    echo "   Taille: $file_size lignes"
    
    # Exécuter avec USE DATABASE
    echo "   Exécution..."
    
    # Créer un script temporaire
    TEMP_FILE=$(mktemp)
    {
        echo "USE \`$DB_NAME\`;"
        echo "SET FOREIGN_KEY_CHECKS=0;"
        echo "SET NAMES utf8mb4;"
        echo ""
        cat "$file"
        echo ""
        echo "SET FOREIGN_KEY_CHECKS=1;"
    } > "$TEMP_FILE"
    
    # Exécuter
    $MYSQL_CMD < "$TEMP_FILE" 2>&1
    local result=$?
    
    # Nettoyer
    rm -f "$TEMP_FILE"
    
    if [ $result -eq 0 ]; then
        print_color green "   ✅ Succès"
        return 0
    else
        print_color red "   ❌ Erreur MySQL (code: $result)"
        return 1
    fi
}

# Créer la base de données
create_database || {
    read -p "Appuyez sur Entrée pour fermer..." -n 1 -r
    exit 1
}

# Liste des scripts dans l'ordre
SCRIPTS=(
    "migrations/00_create_table_user.sql"
    "migrations/01_populate_region_dept_commne_tables.sql"
    "migrations/02_create_views.sql"
    "migrations/03_create_t_tables.sql"
    "migrations/04_populate_t_tables.sql"
    "migrations/05_create_indexes.sql"
    "migrations/06_create_aggregated_tables.sql"
    "migrations/07_populate_aggregated_tables_LAST_V.sql"
)

DESCRIPTIONS=(
    "1/8 - Tables de base (region, departement, commune, user)"
    "2/8 - Données géographiques"
    "3/8 - Création des vues"
    "4/8 - Tables de transformation (t_)"
    "5/8 - Peuplement tables t_"
    "6/8 - Index d'optimisation"
    "7/8 - Tables statistiques agrégées"
    "8/8 - Calcul statistiques"
)

# Journal des réussites
SUCCESS=()

# Exécuter chaque script
for i in "${!SCRIPTS[@]}"; do
    echo ""
    echo "=========================================="
    print_color blue "${DESCRIPTIONS[$i]}"
    echo "=========================================="
    
    script="${SCRIPTS[$i]}"
    description="${DESCRIPTIONS[$i]}"
    
    if run_sql_file "$script" "$description"; then
        SUCCESS+=("${DESCRIPTIONS[$i]}")
    else
        print_color yellow "⚠️  Échec de cette étape"
        
        # Demander si on continue
        if [ $i -lt $((${#SCRIPTS[@]} - 1)) ]; then
            echo ""
            read -p "Continuer avec l'étape suivante? (o/n) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Oo]$ ]]; then
                print_color yellow "🛑 Arrêt demandé"
                break
            fi
        fi
    fi
done

# Résumé
echo ""
echo "=========================================="
echo "📊 RÉSUMÉ DE L'EXÉCUTION"
echo "=========================================="
echo ""
echo "Étapes totales: ${#SCRIPTS[@]}"
echo "Étapes réussies: ${#SUCCESS[@]}"
echo ""

if [ ${#SUCCESS[@]} -eq ${#SCRIPTS[@]} ]; then
    print_color green "🎉 TOUTES LES ÉTAPES ONT RÉUSSI!"
else
    print_color yellow "⚠️  ${#SUCCESS[@]}/${#SCRIPTS[@]} étapes réussies"
    
    # Afficher les étapes manquées
    if [ ${#SUCCESS[@]} -gt 0 ]; then
        echo ""
        print_color green "✅ ÉTAPES RÉUSSIES:"
        for step in "${SUCCESS[@]}"; do
            echo "   ✓ $step"
        done
    fi
fi

# Vérification finale
echo ""
print_color blue "🔍 VÉRIFICATION RAPIDE:"
echo "USE \`$DB_NAME\`; SHOW TABLES;" | $MYSQL_CMD 2>/dev/null | grep -E "(t[0-9]|stats|pyramide)" || echo "   (pas de tables trouvées)"

echo ""
echo "=========================================="
print_color blue "📝 LOG DE L'EXÉCUTION SAUVEGARDÉ DANS migration_log.txt"
# Sauvegarder le log
{
    echo "Migration exécutée le: $(date)"
    echo "Base: $DB_NAME"
    echo "Étapes réussies: ${#SUCCESS[@]}/${#SCRIPTS[@]}"
    echo ""
    echo "Étapes:"
    for step in "${SUCCESS[@]}"; do
        echo "✓ $step"
    done
} > migration_log.txt

# Pause finale
echo ""
read -p "Appuyez sur Entrée pour fermer..." -n 1 -r
echo ""