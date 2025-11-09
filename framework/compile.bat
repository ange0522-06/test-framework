@echo off
REM ========================================
REM   COMPILATION DU FRAMEWORK
REM ========================================

cd /d "%~dp0"

REM Dossier de build pour les classes compilées
set BUILD_DIR=build

REM Supprimer l'ancien build
if exist %BUILD_DIR% rmdir /S /Q %BUILD_DIR%
mkdir %BUILD_DIR%

REM Chemin vers les librairies (si nécessaire)
set LIB_JAR=lib\jakarta.servlet-api-5.0.0.jar

echo [1/3] Compilation du framework...

REM Compilation de toutes les classes du framework
javac -d %BUILD_DIR% ^
src\core\annotations\Controller.java ^
src\core\annotations\Get.java ^
src\core\annotations\MyURL.java ^
src\core\utils\AnnotationScanner.java

REM Note: FrontServlet nécessite servlet-api, on le compile séparément si besoin
if exist %LIB_JAR% (
    javac -cp %LIB_JAR% -d %BUILD_DIR% src\core\FrontServlet.java
) else (
    echo [WARNING] servlet-api non trouvé, FrontServlet ignoré
)

REM Vérifier si compilation OK
if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur de compilation du framework.
    pause
    exit /b %ERRORLEVEL%
)

echo ✓ Compilation OK

REM Création du Framework.jar
echo [2/3] Création de Framework.jar...
cd %BUILD_DIR%
jar cf ..\Framework.jar core
cd ..

REM Vérification
if not exist Framework.jar (
    echo ❌ Erreur lors de la création du JAR
    pause
    exit /b 1
)

echo ✓ Framework.jar créé avec succès !

@REM REM === COPIE VERS LE PROJET TEST ===
@REM echo [3/3] Déploiement vers le projet test...

@REM set "TEST_LIB_DIR=..\test_avec_le_framew\lib"

@REM REM Créer le dossier lib dans test s'il n'existe pas
@REM if not exist "%TEST_LIB_DIR%" mkdir "%TEST_LIB_DIR%"

@REM REM Copier le JAR
@REM copy /Y Framework.jar "%TEST_LIB_DIR%\Framework.jar"

@REM if %ERRORLEVEL% neq 0 (
@REM     echo ❌ Erreur lors de la copie vers le projet test
@REM     pause
@REM     exit /b 1
@REM )

@REM echo ✓ Framework.jar copié dans test\lib\

echo.
echo ========================================
echo   Framework pret et deploye !
echo   - framework\Framework.jar (source)
@REM echo   - test\lib\Framework.jar (copie)
echo ========================================
echo.
echo Contenu du JAR:
@REM jar tf Framework.jar

pause