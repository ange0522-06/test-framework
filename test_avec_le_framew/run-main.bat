@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   BUILD + RUN Main (Test Framework)
echo ========================================
echo.

REM Aller à la racine du script (dossier test)
cd /d "%~dp0"

REM Définir les chemins
set "FRAMEWORK_JAR=..\framework\Framework.jar"
set "TEST_SRC=src\main\java"
set "TEST_OUT=target\classes"

REM Vérifier que le framework est compilé
if not exist "%FRAMEWORK_JAR%" (
    echo ❌ ERREUR: Framework.jar introuvable !
    echo.
    echo Veuillez d'abord compiler le framework:
    echo   cd ..\framework
    echo   compile.bat
    echo.
    pause
    exit /b 1
)

echo ✓ Framework.jar trouvé

REM Créer le dossier de sortie si nécessaire
if not exist "%TEST_OUT%" mkdir "%TEST_OUT%"

REM Compiler le projet test
echo [1/2] Compilation du projet test...
javac -cp "%FRAMEWORK_JAR%" -d "%TEST_OUT%" ^
    "%TEST_SRC%\annotation\Main.java" ^
    "%TEST_SRC%\annotation\Teste.java" ^
    "%TEST_SRC%\annotation\UserController.java" ^
    "%TEST_SRC%\annotation\ProductAPI.java"

if %ERRORLEVEL% neq 0 (
    echo ❌ Erreur de compilation du projet test
    pause
    exit /b 1
)

echo ✓ Compilation du projet test OK

REM Exécution
echo.
echo [2/2] Exécution de annotation.Main...
echo ----------------------------------------
java -cp "%TEST_OUT%;%FRAMEWORK_JAR%" annotation.Main
set RUN_RC=%ERRORLEVEL%
echo ----------------------------------------

if %RUN_RC% neq 0 (
    echo ❌ Erreur lors de l'exécution (code %RUN_RC%)
    pause
    exit /b %RUN_RC%
)

echo.
echo ✓ Exécution terminée avec succès !
pause