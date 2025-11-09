@REM @echo off
@REM REM Variables
@REM set LIB_DIR=lib
@REM set SERVLET_JAR=%LIB_DIR%\servlet-api.jar
@REM set FRAMEWORK_JAR=%LIB_DIR%\Framework.jar
@REM set FRAMEWORK_SRC=..\Framework\src
@REM set OUTPUT_DIR=build
@REM set SOURCE_LIST=sources.txt
@REM set WEBAPPS_PATH=D:\apache-tomcat-10.1.28\webapps
@REM set PROJECT_NAME=script
@REM set TOMCAT_HOME= D:\apache-tomcat-10.1.28
@REM @REM D:\apache-tomcat-10.1.28\webapps

@REM REM Nettoyage préalable du dossier de build
@REM if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"

@REM REM Création du dossier de compilation et des sous-dossiers
@REM mkdir "%OUTPUT_DIR%"
@REM mkdir "%OUTPUT_DIR%\WEB-INF"
@REM mkdir "%OUTPUT_DIR%\WEB-INF\classes"
@REM mkdir "%OUTPUT_DIR%\WEB-INF\lib"
@REM mkdir "%OUTPUT_DIR%\css"
@REM mkdir "%OUTPUT_DIR%\js"

@REM REM Compilation des fichiers Java
@REM echo Compilation des sources Java...
@REM dir /b /s *.java > %SOURCE_LIST%
@REM "C:\Program Files\Java\jdk-17\bin\javac.exe" -cp "%SERVLET_JAR%;%FRAMEWORK_JAR%" -d %OUTPUT_DIR%\WEB-INF\classes @%SOURCE_LIST%

@REM REM Vérification de la compilation
@REM if %ERRORLEVEL% neq 0 (
@REM     echo Erreur de compilation. Arrêt du script.
@REM     exit /b %ERRORLEVEL%
@REM )

@REM REM Copie du fichier web.xml
@REM xcopy /I /Y src\main\webapps\WEB-INF\web.xml %OUTPUT_DIR%\WEB-INF\

@REM REM Copie des fichiers statiques
@REM xcopy /I /Y src\main\webapps\*.html %OUTPUT_DIR%\
@REM xcopy /I /Y src\main\webapps\*.jsp %OUTPUT_DIR%\ 2>nul
@REM xcopy /I /Y /S src\main\webapps\css\*.* %OUTPUT_DIR%\css\ 2>nul
@REM xcopy /I /Y /S src\main\webapps\js\*.* %OUTPUT_DIR%\js\ 2>nul

@REM REM Copie du dossier web (s'il existe)
@REM if exist "src\main\webapps\web" (
@REM     xcopy /e /i /q "src\main\webapps\web" "%OUTPUT_DIR%\web" >nul
@REM )

@REM REM Copie des bibliothèques dans WEB-INF/lib
@REM copy "%LIB_DIR%\*.jar" "%OUTPUT_DIR%\WEB-INF\lib\" >nul

@REM REM Création du fichier .war
@REM echo Création du fichier WAR...
@REM cd %OUTPUT_DIR%
@REM "C:\Program Files\Java\jdk-17\bin\jar.exe" cvf "%PROJECT_NAME%.war" .

@REM REM Arrêt de Tomcat
@REM echo Arrêt de Tomcat...
@REM call "%TOMCAT_HOME%\bin\shutdown.bat"
@REM timeout /t 3 /nobreak >nul

@REM REM Suppression de l'ancien déploiement si existant
@REM if exist "%WEBAPPS_PATH%\%PROJECT_NAME%.war" del "%WEBAPPS_PATH%\%PROJECT_NAME%.war"
@REM if exist "%WEBAPPS_PATH%\%PROJECT_NAME%" rmdir /S /Q "%WEBAPPS_PATH%\%PROJECT_NAME%"

@REM REM Copie du fichier .war vers le répertoire webapps
@REM copy %PROJECT_NAME%.war %WEBAPPS_PATH%
@REM if %ERRORLEVEL% neq 0 (
@REM     echo Erreur lors de la copie du fichier WAR.
@REM     exit /b %ERRORLEVEL%
@REM )

@REM REM Redémarrage de Tomcat
@REM echo Redémarrage de Tomcat...
@REM call "%TOMCAT_HOME%\bin\startup.bat"

@REM REM Retour au répertoire d'origine
@REM cd ..

@REM echo.
@REM echo ✅ Déploiement terminé avec succès !
@REM echo Index : http://localhost:8081/%PROJECT_NAME%/
@REM echo Servlet : http://localhost:8081/%PROJECT_NAME%/hello

@REM pause