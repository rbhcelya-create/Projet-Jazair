@echo off
title Publication Jazair
cd /d "%~dp0"

echo.
echo ====================================
echo   Publication du site Jazair
echo ====================================
echo.

if not exist "%USERPROFILE%\Downloads\data.json" (
  echo [ERREUR] Aucun data.json trouve dans Downloads.
  echo.
  echo Va d'abord sur le CMS, clique "Publier"
  echo puis relance ce script.
  echo.
  pause
  exit /b 1
)

echo Copie de data.json depuis Downloads...
copy /Y "%USERPROFILE%\Downloads\data.json" "data.json" >nul

echo Verification des changements...
git diff --quiet data.json
if %errorlevel%==0 (
  echo.
  echo [INFO] Aucun changement detecte dans data.json.
  echo Le site est deja a jour.
  echo.
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
echo ====================================
echo   OK Publie ! Site mis a jour dans 1-2 min
echo ====================================
echo.
echo Tu peux fermer cette fenetre.
echo.
timeout /t 10
