@echo off
title Publication Jazair
cd /d "%~dp0"

echo.
echo ====================================
echo   Publication du site Jazair
echo ====================================
echo.

REM Trouve le data*.json le plus recent dans Downloads
set "LATEST="
for /f "delims=" %%F in ('dir /b /o-d /a-d "%USERPROFILE%\Downloads\data*.json" 2^>nul') do (
  if not defined LATEST set "LATEST=%USERPROFILE%\Downloads\%%F"
)

if not defined LATEST (
  echo [ERREUR] Aucun data*.json trouve dans Downloads.
  echo.
  echo Va sur le CMS et clique "Publier" d'abord.
  echo.
  pause
  exit /b 1
)

echo Fichier le plus recent : %LATEST%
echo Copie vers le projet...
copy /Y "%LATEST%" "data.json" >nul

echo Verification des changements...
git diff --quiet data.json
if %errorlevel%==0 (
  echo.
  echo [INFO] Aucun changement par rapport au site en ligne.
  echo Le site est deja a jour.
  echo.
  echo Nettoyage des anciens telechargements...
  del /Q "%USERPROFILE%\Downloads\data*.json" 2>nul
  pause
  exit /b 0
)

echo.
echo Envoi sur GitHub...
git add data.json
git commit -m "Update data.json via CMS"
if errorlevel 1 (
  echo.
  echo [ERREUR] Echec du commit.
  pause
  exit /b 1
)

git push
if errorlevel 1 (
  echo.
  echo [ERREUR] Echec du push. Verifie ta connexion.
  pause
  exit /b 1
)

echo.
echo Nettoyage des anciens telechargements...
del /Q "%USERPROFILE%\Downloads\data*.json" 2>nul

echo.
echo ====================================
echo   OK Publie ! Site mis a jour dans 1-2 min
echo ====================================
echo.
echo Tu peux fermer cette fenetre.
echo.
timeout /t 10
