@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   BUILD + RUN Main (sans Maven)
echo ========================================
echo.

REM Aller à la racine du script
cd /d "%~dp0"

REM 1) Compiler le framework
echo [1/3] Compilation du framework...
set "FRAMEWORK_SRC=..\framework\src"
set "FRAMEWORK_OUT=..\framework\build"
if not exist "%FRAMEWORK_OUT%" mkdir "%FRAMEWORK_OUT%"

REM Compiler tous les fichiers .java du framework (récursivement)
setlocal enabledelayedexpansion
set "FILES="

for /r "%FRAMEWORK_SRC%/core/annotations" %%f in (*.java) do (
    rem Accumuler les chemins entre guillemets pour gérer les espaces
    set "FILES=!FILES! "%%f""
)

REM DEBUG: afficher la liste (décommenter si besoin)
REM echo Fichiers à compiler: !FILES!

javac -d "%FRAMEWORK_OUT%" !FILES!
if %ERRORLEVEL% neq 0 (
    echo ERREUR: Echec compilation framework
    endlocal
    exit /b 1
)
echo ✓ Framework compile
endlocal

if %ERRORLEVEL% neq 0 (
    echo ERREUR: Echec compilation framework
    exit /b 1
)
echo ✓ Framework compile

REM Créer le JAR manuellement
echo Creation du JAR framework...
set "FRAMEWORK_JAR=..\framework\FrameworkAnnotation.jar"
jar cf "%FRAMEWORK_JAR%" -C "%FRAMEWORK_OUT%" .
echo ✓ JAR cree: %FRAMEWORK_JAR%

REM 2) Compiler le projet test
echo [2/3] Compilation du projet test...
set "TEST_SRC=src\main\java"
set "TEST_OUT=target\classes"
if not exist "%TEST_OUT%" mkdir "%TEST_OUT%"

javac -cp "%FRAMEWORK_JAR%" -d "%TEST_OUT%" "%TEST_SRC%\annotation\Main.java" "%TEST_SRC%\annotation\Teste.java"
if %ERRORLEVEL% neq 0 (
    echo ERREUR: Echec compilation du projet test
    exit /b 1
)
echo ✓ Compilation du projet test OK

REM 3) Exécution
echo [3/3] Execution de annotation.Main ...
echo ----------------------------------------
java -cp "%TEST_OUT%;%FRAMEWORK_JAR%" annotation.Main
set RUN_RC=%ERRORLEVEL%
echo ----------------------------------------

if %RUN_RC% neq 0 (
  echo ERREUR: L'execution de Main a echoue (code %RUN_RC%)
  exit /b %RUN_RC%
)

echo ✓ Terminé
pause
