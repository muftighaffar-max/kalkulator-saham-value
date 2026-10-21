@echo off
title Push Kalkulator Saham ke GitHub
cd /d "%~dp0"
set PATH=D:\gemini\MinGit\cmd;D:\gemini\MinGit\mingw64\bin;%PATH%

echo ======================================================================
echo          DEPLOY KALKULATOR SAHAM KE GITHUB
echo ======================================================================
echo.
echo Sedang melakukan push ke:
echo https://github.com/muftighaffar-max/kalkulator-saham.git (branch main)
echo.
echo CATATAN AUTHENTICATION:
echo Jika muncul permintaan Username dan Password:
echo 1. Username: muftighaffar-max
echo 2. Password: Gunakan GitHub Personal Access Token (PAT) Anda
echo    (bukan password akun biasa, karena kebijakan keamanan GitHub).
echo.
echo ======================================================================
echo.

git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ======================================================================
    echo [SUKSES] Seluruh file kalkulator saham berhasil ter-push ke GitHub!
    echo ======================================================================
    echo.
    echo Langkah selanjutnya untuk mengaktifkan GitHub Pages:
    echo 1. Buka https://github.com/muftighaffar-max/kalkulator-saham
    echo 2. Klik menu "Settings" (di tab atas sebelah kanan)
    echo 3. Di bilah sisi kiri, klik "Pages"
    echo 4. Pada bagian "Branch", pilih "main" dan folder "/(root)"
    echo 5. Klik "Save"
    echo 6. Tunggu 1-2 menit, web Anda akan live di:
    echo    https://muftighaffar-max.github.io/kalkulator-saham/
    echo ======================================================================
) else (
    echo.
    echo ======================================================================
    echo [INFO] Push belum berhasil atau memerlukan autentikasi.
    echo Jika Anda memiliki Personal Access Token (PAT), Anda bisa menjalankan:
    echo   git remote set-url origin https://TOKEN_ANDA@github.com/muftighaffar-max/kalkulator-saham.git
    echo   git push -u origin main
    echo ======================================================================
)

echo.
pause
