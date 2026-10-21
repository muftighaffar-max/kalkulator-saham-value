@echo off
chcp 65001 >nul
title Sinkronisasi Data Fundamental Saham IHSG
echo ================================================================
echo    SINKRONISASI DATA FUNDAMENTAL OTOMATIS (963 EMITEN BEI)
echo ================================================================
echo.
echo Sedang menjalankan sinkronisasi latar belakang...
echo Mohon tunggu sebentar...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_all_fundamentals.ps1"

echo.
echo Tekan sembarang tombol untuk keluar...
pause >nul
