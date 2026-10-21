@echo off
title Push Kalkulator Saham ke GitHub
cd /d "%~dp0"
set PATH=D:\gemini\MinGit\cmd;D:\gemini\MinGit\mingw64\bin;%PATH%

echo ======================================================================
echo          DEPLOY KALKULATOR SAHAM KE GITHUB
echo ======================================================================
echo.
echo Repositori: https://github.com/muftighaffar-max/kalkulator-saham-value
echo Branch: main
echo.
echo ======================================================================
echo.

git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ======================================================================
    echo [SUKSES] Seluruh pembaruan berhasil di-push ke GitHub!
    echo Situs live Anda:
    echo https://muftighaffar-max.github.io/kalkulator-saham-value/
    echo ======================================================================
) else (
    echo.
    echo ======================================================================
    echo [INFO] Push memerlukan autentikasi token.
    echo Masukkan Username: muftighaffar-max
    echo Password: Gunakan Personal Access Token (PAT) GitHub Anda.
    echo ======================================================================
)

echo.
pause
