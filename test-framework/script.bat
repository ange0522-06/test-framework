@echo off
REM Variables
set LIB_DIR=lib
set SERVLET_JAR=%LIB_DIR%\servlet-api.jar
set FRAMEWORK_JAR=%LIB_DIR%\Framework.jar
set FRAMEWORK_SRC=..\Framework\src
set OUTPUT_DIR=build
set SOURCE_LIST=sources.txt
set WEBAPPS_PATH=D:\logiciels\apache-tomcat-10.1.31\webapps
set PROJECT_NAME=script
set TOMCAT_HOME= D:\apache-tomcat-10.1.28
@REM D:\apache-tomcat-10.1.28\webapps

REM Nettoyage préalable du dossier de build
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

REM Création du dossier de compilation et des sous-dossiers
mkdir "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%\WEB-INF"
mkdir "%OUTPUT_DIR%\WEB-INF\classes"
mkdir "%OUTPUT_DIR%\WEB-INF\lib"
mkdir "%OUTPUT_DIR%\css"
mkdir "%OUTPUT_DIR%\js"

REM Compilation des fichiers Java
echo Compilation des sources Java...
dir /b /s *.java > %SOURCE_LIST%
"C:\Program Files\Java\jdk-17\bin\javac.exe" -cp "%SERVLET_JAR%;%FRAMEWORK_JAR%" -d %OUTPUT_DIR%\WEB-INF\classes @%SOURCE_LIST%

REM Vérification de la compilation
if %ERRORLEVEL% neq 0 (
    echo Erreur de compilation. Arrêt du script.
    exit /b %ERRORLEVEL%
)

REM Copie du fichier web.xml
xcopy /I /Y src\main\webapps\WEB-INF\web.xml %OUTPUT_DIR%\WEB-INF\

REM Copie des fichiers statiques
xcopy /I /Y src\main\webapps\*.html %OUTPUT_DIR%\
xcopy /I /Y src\main\webapps\*.jsp %OUTPUT_DIR%\ 2>nul
xcopy /I /Y /S src\main\webapps\css\*.* %OUTPUT_DIR%\css\ 2>nul
xcopy /I /Y /S src\main\webapps\js\*.* %OUTPUT_DIR%\js\ 2>nul

REM Copie du dossier web (s'il existe)
if exist "src\main\webapps\web" (
    xcopy /e /i /q "src\main\webapps\web" "%OUTPUT_DIR%\web" >nul
)

REM Copie des bibliothèques dans WEB-INF/lib
copy "%LIB_DIR%\*.jar" "%OUTPUT_DIR%\WEB-INF\lib\" >nul

REM Création du fichier .war
echo Création du fichier WAR...
cd %OUTPUT_DIR%
"C:\Program Files\Java\jdk-17\bin\jar.exe" cvf "%PROJECT_NAME%.war" .

REM Arrêt de Tomcat
echo Arrêt de Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat"
timeout /t 3 /nobreak >nul

REM Suppression de l'ancien déploiement si existant
if exist "%WEBAPPS_PATH%\%PROJECT_NAME%.war" del "%WEBAPPS_PATH%\%PROJECT_NAME%.war"
if exist "%WEBAPPS_PATH%\%PROJECT_NAME%" rmdir /S /Q "%WEBAPPS_PATH%\%PROJECT_NAME%"

REM Copie du fichier .war vers le répertoire webapps
copy %PROJECT_NAME%.war %WEBAPPS_PATH%
if %ERRORLEVEL% neq 0 (
    echo Erreur lors de la copie du fichier WAR.
    exit /b %ERRORLEVEL%
)

REM Redémarrage de Tomcat
echo Redémarrage de Tomcat...
call "%TOMCAT_HOME%\bin\startup.bat"

REM Retour au répertoire d'origine
cd ..

echo.
echo ✅ Déploiement terminé avec succès !
echo Index : http://localhost:8080/%PROJECT_NAME%/
echo Servlet : http://localhost:8080/%PROJECT_NAME%/hello

pause