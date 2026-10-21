@echo off
title Update Data 963 Saham BEI (idx.co.id)
color 0A
echo =====================================================================
echo           UPDATE OTOMATIS DATA 963 SAHAM BURSA EFEK INDONESIA
echo =====================================================================
echo.
echo Mencari file Ringkasan Saham terbaru dari folder Downloads...
powershell -ExecutionPolicy Bypass -File "D:\gemini\kalkulator-saham\update_data_otomatis.ps1"
echo.
echo Selesai. Tekan tombol apa saja untuk menutup jendela ini...
pause >nul
