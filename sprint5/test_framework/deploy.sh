#!/bin/bash

# =====================================
# Variables
# =====================================
APP_NAME="test"
SRC="src"
BUILD="build"
LIB_WEBINF="WEB-INF/lib"
CLASSES_WEBINF="WEB-INF/classes"
TOMCAT_LIB="/home/itu/tomcat/lib"
FRAMEWORK_JAR="../Framework/framework.jar"
WAR_NAME="${APP_NAME}.war"
TOMCAT_PATH="/home/itu/tomcat"
WEBAPP_SOURCE="${SRC}/main/webapp"

# =====================================
# Nettoyage
# =====================================
echo "Nettoyage du build..."
rm -rf "$BUILD"
mkdir -p "$BUILD/WEB-INF/classes"
mkdir -p "$BUILD/WEB-INF/lib"

# =====================================
# Compilation
# =====================================
echo "Compilation des fichiers source..."

# Créer la liste des fichiers .java
find "$SRC" -name "*.java" > sources.txt

# Compiler
javac -classpath "$TOMCAT_LIB/servlet-api.jar:$FRAMEWORK_JAR" -d "$BUILD/WEB-INF/classes" @sources.txt

if [ $? -ne 0 ]; then
    echo "Erreur de compilation!"
    rm -f sources.txt
    exit 1
fi

rm -f sources.txt

# =====================================
# Copier framework.jar
# =====================================
echo "Copie du framework.jar..."
cp -f "$FRAMEWORK_JAR" "$BUILD/WEB-INF/lib/"

# =====================================
# COPIE COMPLETE DE WEB-INF
# =====================================
echo "Copie de tous les fichiers et dossiers WEB-INF..."

if [ -d "$WEBAPP_SOURCE/WEB-INF" ]; then
    # Copier tous les fichiers à la racine de WEB-INF
    for file in "$WEBAPP_SOURCE/WEB-INF"/*; do
        if [ -f "$file" ]; then
            cp -f "$file" "$BUILD/WEB-INF/"
            echo "✅ $(basename "$file") copié"
        fi
    done
    
    # Copier tous les sous-dossiers et leur contenu (sauf classes et lib)
    for dir in "$WEBAPP_SOURCE/WEB-INF"/*; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            if [ "$dirname" != "classes" ] && [ "$dirname" != "lib" ]; then
                cp -rf "$dir" "$BUILD/WEB-INF/"
                echo "✅ WEB-INF/$dirname copié"
            fi
        fi
    done
    
    echo "✅ Contenu complet de WEB-INF copié"
else
    echo "⚠️ ATTENTION: $WEBAPP_SOURCE/WEB-INF n'existe pas!"
fi

# =====================================
# COPIE DES RESSOURCES PUBLIQUES
# =====================================
echo "Copie des ressources publiques..."

# Copier les fichiers JSP
if ls "$WEBAPP_SOURCE"/*.jsp 1> /dev/null 2>&1; then
    cp -f "$WEBAPP_SOURCE"/*.jsp "$BUILD/"
    echo "✅ Fichiers JSP publics copiés"
fi

# Copier les fichiers HTML
if ls "$WEBAPP_SOURCE"/*.html 1> /dev/null 2>&1; then
    cp -f "$WEBAPP_SOURCE"/*.html "$BUILD/"
    echo "✅ Fichiers HTML publics copiés"
fi

# Copier les fichiers CSS
if ls "$WEBAPP_SOURCE"/*.css 1> /dev/null 2>&1; then
    cp -f "$WEBAPP_SOURCE"/*.css "$BUILD/"
    echo "✅ Fichiers CSS copiés"
fi

# Copier les fichiers JS
if ls "$WEBAPP_SOURCE"/*.js 1> /dev/null 2>&1; then
    cp -f "$WEBAPP_SOURCE"/*.js "$BUILD/"
    echo "✅ Fichiers JS copiés"
fi

# Copier tous les dossiers publics (sauf WEB-INF et META-INF)
for dir in "$WEBAPP_SOURCE"/*; do
    if [ -d "$dir" ]; then
        dirname=$(basename "$dir")
        if [ "$dirname" != "WEB-INF" ] && [ "$dirname" != "META-INF" ]; then
            cp -rf "$dir" "$BUILD/"
            echo "✅ $dirname copié"
        fi
    fi
done

# Copier META-INF
if [ -d "$WEBAPP_SOURCE/META-INF" ]; then
    cp -rf "$WEBAPP_SOURCE/META-INF" "$BUILD/"
    echo "✅ META-INF copié"
fi

# =====================================
# Vérifier la structure
# =====================================
echo ""
echo "📁 Structure créée dans $BUILD:"
ls -1 "$BUILD"
echo ""
echo "📁 Contenu de WEB-INF:"
ls -1 "$BUILD/WEB-INF"
echo ""

if [ -d "$BUILD/WEB-INF/views" ]; then
    echo "📁 Contenu de WEB-INF/views:"
    find "$BUILD/WEB-INF/views" -type f
    echo ""
fi

# =====================================
# Créer le WAR
# =====================================
echo "Création du WAR..."
cd "$BUILD"
jar cvf "../$WAR_NAME" . > /dev/null
cd ..

echo "✅ $WAR_NAME généré avec succès"

# =====================================
# Déployer sur Tomcat
# =====================================
echo "Déploiement sur Tomcat..."
cp -f "$WAR_NAME" "$TOMCAT_PATH/webapps/"

echo ""
echo "🎯 DEPLOIEMENT TERMINE!"
echo ""
echo "Pour voir les logs Tomcat:"
echo "  tail -f $TOMCAT_PATH/logs/catalina.out"
echo ""
echo "Pour redémarrer Tomcat:"
echo "  $TOMCAT_PATH/bin/shutdown.sh"
echo "  $TOMCAT_PATH/bin/startup.sh"
echo ""